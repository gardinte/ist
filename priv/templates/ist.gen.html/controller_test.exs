defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>ControllerTest do
  use <%= inspect context.web_module %>.ConnCase
  use <%= inspect context.base_module %>.Support.LoginHelper

  import <%= inspect context.base_module %>.Support.FixtureHelper

  @create_attrs <%= inspect schema.params.create %>
  @update_attrs <%= inspect schema.params.update %>
  @invalid_attrs <%= inspect for {key, _} <- schema.params.create, into: %{}, do: {key, nil} %>

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each([
        get(conn,    Routes.<%= schema.route_helper %>_path(conn, :index)),
        get(conn,    Routes.<%= schema.route_helper %>_path(conn, :new)),
        post(conn,   Routes.<%= schema.route_helper %>_path(conn, :create, %{})),
        get(conn,    Routes.<%= schema.route_helper %>_path(conn, :show, "123")),
        get(conn,    Routes.<%= schema.route_helper %>_path(conn, :edit, "123")),
        put(conn,    Routes.<%= schema.route_helper %>_path(conn, :update, "123", %{})),
        delete(conn, Routes.<%= schema.route_helper %>_path(conn, :delete, "123"))
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
    end
  end

  describe "index" do
    setup [:create_<%= schema.singular %>]

    @tag login_as: "test@user.com"
    test "lists all <%= schema.plural %>", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn     = get conn, Routes.<%= schema.route_helper %>_path(conn, :index)
      response = html_response(conn, 200)

      assert response =~ "<%= schema.human_plural %>"
      assert response =~ <%= schema.singular %>.<%= schema.types |> Enum.at(0) |> Tuple.to_list() |> hd() %>
    end
  end

  describe "empty index" do
    @tag login_as: "test@user.com"
    test "lists no <%= schema.plural %>", %{conn: conn} do
      conn = get conn, Routes.<%= schema.route_helper %>_path(conn, :index)

      assert html_response(conn, 200) =~ "you have no <%= schema.plural %>"
    end
  end

  describe "new <%= schema.singular %>" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.<%= schema.route_helper %>_path(conn, :new)

      assert html_response(conn, 200) =~ "New <%= schema.singular %>"
    end
  end

  describe "create <%= schema.singular %>" do
    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.<%= schema.route_helper %>_path(conn, :create), <%= schema.singular %>: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.<%= schema.route_helper %>_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.<%= schema.route_helper %>_path(conn, :create), <%= schema.singular %>: @invalid_attrs

      assert html_response(conn, 200) =~ "New <%= schema.singular %>"
    end
  end

  describe "edit <%= schema.singular %>" do
    setup [:create_<%= schema.singular %>]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen <%= schema.singular %>", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = get conn, Routes.<%= schema.route_helper %>_path(conn, :edit, <%= schema.singular %>)

      assert html_response(conn, 200) =~ "Edit <%= schema.singular %>"
    end
  end

  describe "update <%= schema.singular %>" do
    setup [:create_<%= schema.singular %>]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = put conn, Routes.<%= schema.route_helper %>_path(conn, :update, <%= schema.singular %>), <%= schema.singular %>: @update_attrs

      assert redirected_to(conn) == Routes.<%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = put conn, Routes.<%= schema.route_helper %>_path(conn, :update, <%= schema.singular %>), <%= schema.singular %>: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit <%= schema.singular %>"
    end
  end

  describe "delete <%= schema.singular %>" do
    setup [:create_<%= schema.singular %>]

    @tag login_as: "test@user.com"
    test "deletes chosen <%= schema.singular %>", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      conn = delete conn, Routes.<%= schema.route_helper %>_path(conn, :delete, <%= schema.singular %>)

      assert redirected_to(conn) == Routes.<%= schema.route_helper %>_path(conn, :index)
    end
  end

  defp create_<%= schema.singular %>(_) do
    {:ok, <%= schema.singular %>, _} = fixture(:<%= schema.singular %>)

    {:ok, <%= schema.singular %>: <%= schema.singular %>}
  end
end
