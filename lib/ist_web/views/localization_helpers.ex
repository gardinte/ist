defmodule IstWeb.LocalizationHelpers do
  import IstWeb.Gettext

  def l(_conn, date, format: format) do
    {:ok, text} = Timex.format(date, format_for(date, format))

    text
  end

  defp format_for(%Date{}, :compact) do
    dgettext("format", "date.compact")
  end

  defp format_for(%DateTime{}, :compact) do
    dgettext("format", "datetime.compact")
  end
end
