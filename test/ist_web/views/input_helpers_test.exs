defmodule IstWeb.InputHelpersTest do
  use IstWeb.ConnCase, async: true

  import Phoenix.HTML, only: [html_escape: 1, safe_to_string: 1]

  describe "input" do
    import IstWeb.InputHelpers
    import Phoenix.HTML.Form, only: [form_for: 4]

    test "with default options", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name)
          |> input_to_string()

        assert input =~ "<input"
        assert input =~ "Name"
        assert input =~ "class=\"field\""
        assert input =~ "class=\"control\""
        assert input =~ "class=\"input\""
        assert input =~ "class=\"label\""
        refute input =~ "is-expanded"
        refute input =~ "has-icons"
        ""
      end)
    end

    test "with custom input options", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, input_html: [class: "test-input-class"])
          |> input_to_string()

        assert input =~ "<input"
        assert input =~ "test-input-class"
        refute input =~ "is-expanded"
        refute input =~ "input_html"
        ""
      end)
    end

    test "with custom label options", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, "Test label", label_html: [class: "test-label-class"])
          |> input_to_string()

        assert input =~ "<input"
        assert input =~ "Test label"
        assert input =~ "test-label-class"
        refute input =~ "is-expanded"
        refute input =~ "label_html"
        ""
      end)
    end

    test "with using option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, using: :password_input)
          |> input_to_string()

        assert input =~ "<input"
        assert input =~ "type=\"password\""
        refute input =~ "is-expanded"
        refute input =~ "using"
        ""
      end)
    end

    test "with using textarea option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, using: :textarea)
          |> input_to_string()

        assert input =~ "<textarea"
        assert input =~ "class=\"textarea\""
        refute input =~ "is-expanded"
        refute input =~ "using"
        ""
      end)
    end

    test "with collection option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, collection: [1, 2, 3])
          |> input_to_string()

        assert input =~ "<select"
        assert input =~ "<div class=\"select is-fullwidth\">"
        assert input =~ "<option value=\"1\">1</option>"
        assert input =~ "<option value=\"2\">2</option>"
        assert input =~ "<option value=\"3\">3</option>"
        refute input =~ "is-expanded"
        refute input =~ "collection"
        ""
      end)
    end

    test "with icons option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, icons: [left: "envelope", right: "warning"])
          |> input_to_string()

        assert input =~ "<input"
        assert input =~ "has-icons-left has-icons-right"
        assert input =~ "is-left"
        assert input =~ "is-right"
        assert input =~ "fa-envelope"
        assert input =~ "fa-warning"
        refute input =~ "is-expanded"
        refute input =~ "icons="
        ""
      end)
    end

    test "with icons left option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, icons: [left: "envelope"])
          |> input_to_string()

        assert input =~ "<input"
        assert input =~ "has-icons-left"
        refute input =~ "has-icons-right"
        assert input =~ "is-left"
        refute input =~ "is-right"
        assert input =~ "fa-envelope"
        refute input =~ "is-expanded"
        refute input =~ "icons="
        ""
      end)
    end

    test "with addons option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, addons: [left: "l$", right: "r$"])
          |> input_to_string()

        assert input =~ "<div class=\"field has-addons\">"
        assert input =~ "<input"
        assert input =~ "<a class=\"button is-static\">l$</a>"
        assert input =~ "<a class=\"button is-static\">r$</a>"
        assert input =~ "is-expanded"
        refute input =~ "addons="
        ""
      end)
    end
  end

  defp input_to_string(input) do
    input
    |> html_escape()
    |> safe_to_string()
  end
end
