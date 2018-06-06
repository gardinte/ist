  alias <%= inspect schema.module %>

  @doc """
  Returns the list of <%= schema.plural %>.

  ## Examples

      iex> list_<%= schema.plural %>(%Account{}, %{})
      [%<%= inspect schema.alias %>{}, ...]

  """
  def list_<%= schema.plural %>(account, params) do
    <%= inspect schema.alias %>
    |> prefixed(account)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single <%= schema.singular %>.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> get_<%= schema.singular %>!(%Account{}, 123)
      %<%= inspect schema.alias %>{}

      iex> get_<%= schema.singular %>!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_<%= schema.singular %>!(account, id) do
    <%= inspect schema.alias %>
    |> prefixed(account)
    |> Repo.get!(id)
  end

  @doc """
  Creates a <%= schema.singular %>.

  ## Examples

      iex> create_<%= schema.singular %>(%Session{}, %{field: value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> create_<%= schema.singular %>(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_<%= schema.singular %>(%Session{account: account, user: user}, attrs) do
    account
    |> <%= inspect schema.alias %>.changeset(%<%= inspect schema.alias %>{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a <%= schema.singular %>.

  ## Examples

      iex> update_<%= schema.singular %>(%Session{}, <%= schema.singular %>, %{field: new_value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> update_<%= schema.singular %>(%Session{}, <%= schema.singular %>, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_<%= schema.singular %>(%Session{account: account, user: user}, %<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
    account
    |> <%= inspect schema.alias %>.changeset(<%= schema.singular %>, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a <%= inspect schema.alias %>.

  ## Examples

      iex> delete_<%= schema.singular %>(%Session{}, <%= schema.singular %>)
      {:ok, %<%= inspect schema.alias %>{}}

      iex> delete_<%= schema.singular %>(%Session{}, <%= schema.singular %>)
      {:error, %Ecto.Changeset{}}

  """
  def delete_<%= schema.singular %>(%Session{account: account, user: user}, %<%= inspect schema.alias %>{} = <%= schema.singular %>) do
    Trail.delete(<%= schema.singular %>, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking <%= schema.singular %> changes.

  ## Examples

      iex> change_<%= schema.singular %>(%Account{}, <%= schema.singular %>)
      %Ecto.Changeset{source: %<%= inspect schema.alias %>{}}

  """
  def change_<%= schema.singular %>(%Account{} = account, %<%= inspect schema.alias %>{} = <%= schema.singular %>) do
    <%= inspect schema.alias %>.changeset(account, <%= schema.singular %>, %{})
  end
