
  describe "<%= schema.plural %>" do
    alias <%= inspect schema.module %>

    @valid_attrs <%= inspect schema.params.create %>
    @update_attrs <%= inspect schema.params.update %>
    @invalid_attrs <%= inspect for {key, _} <- schema.params.create, into: %{}, do: {key, nil} %>

    test "list_<%= schema.plural %>/2 returns all <%= schema.plural %>" do
      {:ok, <%= schema.singular %>, account} = fixture(:<%= schema.singular %>)

      assert <%= inspect context.alias %>.list_<%= schema.plural %>(account, %{}).entries == [<%= schema.singular %>]
    end

    test "get_<%= schema.singular %>!/2 returns the <%= schema.singular %> with given id" do
      {:ok, <%= schema.singular %>, account} = fixture(:<%= schema.singular %>)

      assert <%= inspect context.alias %>.get_<%= schema.singular %>!(account, <%= schema.singular %>.id) == <%= schema.singular %>
    end

    test "create_<%= schema.singular %>/2 with valid data creates a <%= schema.singular %>" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      assert {:ok, %<%= inspect schema.alias %>{} = <%= schema.singular %>} = <%= inspect context.alias %>.create_<%= schema.singular %>(session, @valid_attrs)<%= for {field, value} <- schema.params.create do %>
      assert <%= schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(schema, field, value) %><% end %>
    end

    test "create_<%= schema.singular %>/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = <%= inspect context.alias %>.create_<%= schema.singular %>(%Session{}, @invalid_attrs)
    end

    test "update_<%= schema.singular %>/3 with valid data updates the <%= schema.singular %>" do
      {:ok, <%= schema.singular %>, account} = fixture(:<%= schema.singular %>)
      session = %Session{account: account}

      assert {:ok, <%= schema.singular %>} = <%= inspect context.alias %>.update_<%= schema.singular %>(session, <%= schema.singular %>, @update_attrs)
      assert %<%= inspect schema.alias %>{} = <%= schema.singular %><%= for {field, value} <- schema.params.update do %>
      assert <%= schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(schema, field, value) %><% end %>
    end

    test "update_<%= schema.singular %>/3 with invalid data returns error changeset" do
      {:ok, <%= schema.singular %>, account} = fixture(:<%= schema.singular %>)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} = <%= inspect context.alias %>.update_<%= schema.singular %>(session, <%= schema.singular %>, @invalid_attrs)
      assert <%= schema.singular %> == <%= inspect context.alias %>.get_<%= schema.singular %>!(account, <%= schema.singular %>.id)
    end

    test "delete_<%= schema.singular %>/2 deletes the <%= schema.singular %>" do
      {:ok, <%= schema.singular %>, account} = fixture(:<%= schema.singular %>)
      session = %Session{account: account}

      assert {:ok, %<%= inspect schema.alias %>{}} = <%= inspect context.alias %>.delete_<%= schema.singular %>(session, <%= schema.singular %>)
      assert_raise Ecto.NoResultsError, fn -> <%= inspect context.alias %>.get_<%= schema.singular %>!(account, <%= schema.singular %>.id) end
    end

    test "change_<%= schema.singular %>/2 returns a <%= schema.singular %> changeset" do
      {:ok, <%= schema.singular %>, account} = fixture(:<%= schema.singular %>)

      assert %Ecto.Changeset{} = <%= inspect context.alias %>.change_<%= schema.singular %>(account, <%= schema.singular %>)
    end
  end
