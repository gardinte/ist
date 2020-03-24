defmodule IstWeb.LocalizationHelpersTest do
  use IstWeb.ConnCase, async: true

  describe "localization" do
    import IstWeb.LocalizationHelpers

    test "l", %{conn: conn} do
      date = DateTime.utc_now()
      expected = Timex.format!(date, "{0M}/{0D}/{0YY}")

      assert l(conn, date, format: :compact) =~ expected
    end
  end
end
