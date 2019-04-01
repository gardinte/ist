ARG APP_HOME=/app

# ----------------------
# --- Assets builder ---
# ----------------------
FROM node:lts-alpine AS assets_build

LABEL stage=intermediate

ARG APP_HOME

RUN mkdir $APP_HOME

WORKDIR $APP_HOME/assets

ADD . $APP_HOME

RUN yarn install && yarn build

# ----------------------
# ---- App builder -----
# ----------------------
FROM elixir:alpine AS build

LABEL stage=intermediate

ARG APP_HOME
ENV MIX_ENV prod

RUN apk add --update --no-cache build-base

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

RUN mix local.hex --force && mix local.rebar --force

ADD . $APP_HOME
COPY --from=assets_build $APP_HOME/priv/static ./priv/static
RUN mix deps.get && mix phx.digest && mix release --no-tar

# ----------------------
# --- Release image ----
# ----------------------
FROM alpine:latest

ARG APP_HOME

RUN apk add --update --no-cache bash openssl
RUN mkdir $APP_HOME && chown -R nobody: $APP_HOME

WORKDIR $APP_HOME

USER nobody

COPY --from=build $APP_HOME/_build/prod/rel/ist ./

ENV REPLACE_OS_VARS true
ENV ELIXIR_APP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $ELIXIR_APP_PORT $BEAM_PORT $ERL_EPMD_PORT

ENTRYPOINT [ "/app/bin/ist" ]
CMD [ "foreground" ]
