defmodule <%= inspect schema.module %> do
  use Ecto.Schema

  import Ecto.Changeset
  import <%= inspect context.base_module %>.Accounts.Account, only: [prefix: 1]

  alias <%= inspect schema.module %>
  alias <%= inspect context.base_module %>.Accounts.Account

<%= if schema.binary_id do %>
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id<% end %>
  schema <%= inspect schema.table %> do
<%= for {k, v} <- schema.types do %>    field <%= inspect k %>, <%= inspect v %><%= schema.defaults[k] %>
<% end %><%= for {_, k, _, _} <- schema.assocs do %>    field <%= inspect k %>, <%= if schema.binary_id do %>:binary_id<% else %>:id<% end %>
<% end %>    field :lock_version, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
    <%= schema.singular %>
    |> cast(attrs, [<%= Enum.map_join(schema.attrs ++ [{:lock_version, :integer}], ", ", &inspect(elem(&1, 0))) %>])
    |> validate_required([<%= Enum.map_join(schema.attrs, ", ", &inspect(elem(&1, 0))) %>])
<%= for k <- schema.uniques do %>    |> unsafe_validate_unique(<%= inspect k %>, <%= inspect schema.repo %>, prefix: prefix(account))
    |> unique_constraint(<%= inspect k %>)
<% end %>    |> optimistic_lock(:lock_version)
  end
end
