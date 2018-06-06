defmodule <%= inspect schema.repo %>.Migrations.Create<%= Macro.camelize(schema.table) %> do
  use <%= inspect context.base_module %>, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:<%= schema.table %><%= if schema.binary_id do %>, primary_key: false<% end %>, prefix: prefix) do
<%= if schema.binary_id do %>      add :id, :binary_id, primary_key: true
<% end %><%= for {k, v} <- schema.attrs do %>      add <%= inspect k %>, <%= inspect v %><%= schema.migration_defaults[k] %>
<% end %><%= for {_, i, _, s} <- schema.assocs do %>      add <%= if(String.ends_with?(inspect(i), "_id"), do: inspect(i), else: inspect(i) <> "_id") %>, references(<%= inspect(s) %>, on_delete: :nothing<%= if schema.binary_id do %>, type: :binary_id<% end %>)
<% end %>      add :lock_version, :integer, default: 1, null: false

      timestamps()
    end
<%= for index <- schema.indexes do %>
    <%= index %><% end %>
  end
end
