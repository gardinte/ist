defmodule IstWeb.InputHelpers do
  import Phoenix.HTML.Form, only: [humanize: 1, input_type: 2, input_validations: 2, label: 4]
  import Phoenix.HTML.Tag, only: [content_tag: 3]
  import IstWeb.ErrorHelpers, only: [error_tag: 2]

  def input(form, field, label \\ nil, opts \\ []) do
    type = opts[:using] || input_type(form, field, opts)
    icon_opts = opts[:icons] || []
    label_html = opts[:label_html] || [class: "label"]
    addons = opts[:addons]
    input_opts = input_opts(type, opts)
    errors = error_tag(form, field)
    label = label_for(form, field, label, label_html)

    field =
      content_tag :div, class: field_class(opts) do
        input = input(type, form, field, errors, icon_opts, input_opts, addons)

        [addons(addons, :left, errors), input, addons(addons, :right, errors)]
      end

    [label, field, errors]
  end

  defp input_type(form, field, opts) do
    if is_list(opts[:collection]) do
      :select
    else
      input_type(form, field)
    end
  end

  defp label_for(form, field, nil, label_html) do
    label(form, field, humanize(field), label_html)
  end

  defp label_for(form, field, label, label_html) do
    label(form, field, label, label_html)
  end

  defp input(type, form, field, errors, icon_opts, opts, addons) do
    input_opts = input_opts(type, form, field, errors, opts)
    input = wrapped_input(type, form, field, errors, input_opts)
    content_opts = [class: wrapper_classes(icon_opts, addons)]

    content_tag :div, content_opts do
      [input | input_icons(icon_opts)]
    end
  end

  defp addons(nil, _, _), do: ""

  defp addons(addons, position, errors) do
    addon = addons[position]

    if addon do
      case errors do
        [] -> content_tag(:a, addon, class: "button is-static")
        _ -> content_tag(:a, addon, class: "button is-danger")
      end
    else
      ""
    end
  end

  defp input_opts(:select, opts) do
    input_opts(nil, opts)
    |> Keyword.put(:collection, opts[:collection] || [])
  end

  defp input_opts(_type, opts) do
    opts = opts[:input_html] || []

    opts |> Keyword.put(:addons, opts[:addons])
  end

  defp input_opts(type, form, field, errors, opts) do
    {class, opts} = Keyword.pop(opts, :class)
    default_opts = [class: input_class(type, class, errors)]
    validations = input_validations(type, form, field)

    default_opts
    |> Keyword.merge(validations)
    |> Keyword.merge(opts)
  end

  defp input_class(:textarea, nil, errors) do
    input_class(:textarea, "textarea", errors)
  end

  defp input_class(type, nil, errors) when type != :select do
    input_class(:input, "input", errors)
  end

  defp input_class(_, default, []), do: default
  defp input_class(_, default, _), do: "#{default} is-danger"

  defp input_validations(:select, form, field) do
    input_validations(form, field) |> Keyword.delete(:maxlength)
  end

  defp input_validations(_, form, field), do: input_validations(form, field)

  defp input_icons(icon_opts) do
    for {position, icon} <- icon_opts do
      content_tag :span, class: "icon is-#{position}" do
        content_tag(:i, "", class: "fas fa-#{icon}")
      end
    end
  end

  defp field_class(opts) do
    if is_list(opts[:addons]) do
      "field has-addons"
    else
      "field"
    end
  end

  defp wrapper_classes(icon_opts, addons) when is_list(addons) do
    wrapper_classes(icon_opts, "control is-expanded")
  end

  defp wrapper_classes(icon_opts, nil) do
    wrapper_classes(icon_opts, "control")
  end

  defp wrapper_classes(icon_opts, base_class) when is_binary(base_class) do
    icon_classes = for {position, _} <- icon_opts, do: "has-icons-#{position}"

    [base_class | icon_classes] |> Enum.join(" ")
  end

  defp wrapped_input(:select = type, form, field, errors, input_opts) do
    {options, input_opts} = Keyword.pop(input_opts, :collection)
    class = input_class(:input, "select is-fullwidth", errors)

    content_tag :div, class: class do
      apply(Phoenix.HTML.Form, type, [form, field, options, input_opts])
    end
  end

  defp wrapped_input(type, form, field, _errors, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
