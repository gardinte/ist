defmodule Ist.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ist.Accounts.{Account, User}
  alias Ist.Repo

  schema "users" do
    field :email, :string
    field :lastname, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_reset_token, :string
    field :password_reset_sent_at, :utc_datetime
    field :lock_version, :integer, default: 1

    belongs_to :account, Account

    timestamps()
  end

  @cast_attrs [:name, :lastname, :email, :password, :lock_version]

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @cast_attrs)
    |> validation()
  end

  @doc false
  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @cast_attrs)
    |> validate_required([:password, :account_id])
    |> validation()
  end

  @doc false
  def password_reset_token_changeset(%User{} = user) do
    attrs = %{
      password_reset_token: random_token(64),
      password_reset_sent_at: DateTime.utc_now()
    }

    user
    |> cast(attrs, [:password_reset_token, :password_reset_sent_at])
    |> validate_required([:password_reset_token, :password_reset_sent_at])
  end

  @doc false
  def password_reset_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, required: true)
    |> put_password_hash()
  end

  defp validation(changeset) do
    changeset
    |> validate_required([:name, :lastname, :email])
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> validate_length(:name, max: 255)
    |> validate_length(:lastname, max: 255)
    |> validate_length(:email, max: 255)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> unsafe_validate_unique(:email, Repo)
    |> unique_constraint(:email)
    |> assoc_constraint(:account)
    |> optimistic_lock(:lock_version)
    |> put_password_hash()
  end

  defp put_password_hash(%{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset

  defp random_token(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
