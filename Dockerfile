ARG APP_HOME=/opt/app

# ----------------------
# -- Deps for assets ---
# ----------------------
FROM elixir:alpine AS assets_deps

LABEL stage=intermediate

ARG APP_HOME
ENV MIX_ENV prod

RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

COPY mix.* $APP_HOME/

RUN mix local.hex --force         && \
    mix local.rebar --force       && \
    mix deps.get --only $MIX_ENV

# ----------------------
# --- Assets builder ---
# ----------------------
FROM node:alpine AS assets_build

LABEL stage=intermediate

ARG APP_HOME

RUN mkdir -p $APP_HOME/assets && mkdir -p $APP_HOME/deps

COPY assets/package.json $APP_HOME/assets
COPY assets/yarn.lock $APP_HOME/assets

COPY --from=assets_deps $APP_HOME/deps/phoenix $APP_HOME/deps/phoenix
COPY --from=assets_deps $APP_HOME/deps/phoenix_html $APP_HOME/deps/phoenix_html

WORKDIR $APP_HOME/assets

RUN yarn install

COPY . $APP_HOME

RUN yarn build

# ----------------------
# ---- App builder -----
# ----------------------
FROM elixir:alpine AS build

LABEL stage=intermediate

ARG APP_HOME
ENV MIX_ENV prod

RUN apk add --update --no-cache build-base

RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

COPY mix.* $APP_HOME/

RUN mix local.hex --force         && \
    mix local.rebar --force       && \
    mix deps.get --only $MIX_ENV

COPY . $APP_HOME
COPY --from=assets_build $APP_HOME/priv/static ./priv/static
RUN mix phx.digest && mix release

# ----------------------
# --- Release image ----
# ----------------------
FROM alpine

ARG APP_HOME
ENV USER nobody
ENV MIX_ENV prod

RUN apk add --update --no-cache ncurses
RUN mkdir -p $APP_HOME && chown -R $USER: $APP_HOME

WORKDIR $APP_HOME

COPY --from=build $APP_HOME/_build/prod/rel/ist ./

RUN chown -R $USER: $APP_HOME

USER $USER

ENV ELIXIR_APP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $ELIXIR_APP_PORT $BEAM_PORT $ERL_EPMD_PORT

ENTRYPOINT [ "bin/ist" ]
CMD [ "start" ]
