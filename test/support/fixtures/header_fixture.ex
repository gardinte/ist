defmodule Ist.Support.Fixtures.HeaderFixture do
  defmacro __using__(_opts) do
    quote do
      def fixture(type, attributes \\ %{}, opts \\ [])
    end
  end
end
