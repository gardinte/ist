defmodule IstWeb.LinkHelpersTest do
  use IstWeb.ConnCase, async: true

  describe "link" do
    import IstWeb.LinkHelpers
    import Phoenix.HTML, only: [safe_to_string: 1]

    test "with default options" do
      link =
        icon_link("test", to: "#test")
        |> safe_to_string

      assert link =~ "fas fa-test"
      assert link =~ "href=\"#test\""
    end
  end
end
