defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>View do
  use <%= inspect context.web_module %>, :view
  use Scrivener.HTML

  def link_to_show(conn, <%= schema.singular %>) do
    icon_link "eye",
      title: dgettext("<%= schema.plural %>", "Show"),
      to:    Routes.<%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>),
      class: "button is-small is-outlined is-hidden-mobile"
  end

  def link_to_edit(conn, <%= schema.singular %>) do
    icon_link "pencil-alt",
      title: dgettext("<%= schema.plural %>", "Edit"),
      to:    Routes.<%= schema.route_helper %>_path(conn, :edit, <%= schema.singular %>),
      class: "button is-small is-outlined is-hidden-mobile"
  end

  def link_to_delete(conn, <%= schema.singular %>) do
    icon_link "trash",
      title:  dgettext("<%= schema.plural %>", "Delete"),
      to:     Routes.<%= schema.route_helper %>_path(conn, :delete, <%= schema.singular %>),
      method: :delete,
      data:   [confirm: dgettext("<%= schema.plural %>", "Are you sure?")],
      class:  "button is-small is-danger is-outlined"
  end

  def lock_version_input(_, nil), do: nil
  def lock_version_input(form, <%= schema.singular %>) do
    hidden_input form, :lock_version, [value: <%= schema.singular %>.lock_version]
  end

  def submit_button(<%= schema.singular %>) do
    submit_label(<%= schema.singular %>)
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  defp submit_label(nil), do: dgettext("<%= schema.plural %>", "Create")
  defp submit_label(_),   do: dgettext("<%= schema.plural %>", "Update")
end
