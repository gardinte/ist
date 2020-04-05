defmodule Ist.Recorder do
  @moduledoc """
  The Recorder context.
  """

  import Ecto.Query, warn: false
  import Ist.Accounts.Account, only: [prefix: 1]
  import Ist.Helpers

  alias Ist.Repo
  alias Ist.Trail
  alias Ist.Accounts.{Account, Session}
  alias Ist.Recorder.Device

  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices(%Account{}, %{})
      [%Device{}, ...]

  """
  def list_devices(account, params) do
    Device
    |> prefixed(account)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(%Account{}, 123)
      %Device{}

      iex> get_device!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(account, id) do
    Device
    |> prefixed(account)
    |> Repo.get!(id)
  end

  @doc """
  Gets a single device by UUID.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device_by_uuid!(%Account{}, "43caacd6-ccc4-439d-97db-4a4883e0eae5")
      %Device{}

      iex> get_device_by_uuid!(%Account{}, "9c057527-4ac2-433b-9340-cbccc97dd8dd")
      ** (Ecto.NoResultsError)

  """
  def get_device_by_uuid!(account, uuid) do
    Device
    |> prefixed(account)
    |> Repo.get_by!(uuid: uuid)
  end

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%Session{}, %{field: value})
      {:ok, %Device{}}

      iex> create_device(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(%Session{account: account, user: user} = session, attrs) do
    account
    |> Device.changeset(%Device{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
    |> Device.record(session)
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(%Session{}, device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(%Session{}, device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Session{account: account, user: user}, %Device{} = device, attrs) do
    account
    |> Device.changeset(device, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a device status.

  ## Examples

      iex> update_device_status!(%Session{}, device, "recording")
      %Device{}

      iex> update_device_status!(%Session{}, device, "invalid")
      ** (Ecto.InvalidChangesetError)

  """
  def update_device_status!(%Session{}, %Device{status: status} = device, status), do: device

  def update_device_status!(%Session{account: account, user: user}, %Device{} = device, status) do
    result =
      account
      |> Device.changeset(device, %{status: status})
      |> Trail.update(prefix: prefix(account), originator: user)

    case result do
      {:ok, device} ->
        device

      {:error, changeset} ->
        raise Ecto.InvalidChangesetError, action: :update, changeset: changeset
    end
  end

  @doc """
  Deletes a Device.

  ## Examples

      iex> delete_device(%Session{}, device)
      {:ok, %Device{}}

      iex> delete_device(%Session{}, device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Session{account: account, user: user}, %Device{} = device) do
    Trail.delete(device, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(%Account{}, device)
      %Ecto.Changeset{source: %Device{}}

  """
  def change_device(%Account{} = account, %Device{} = device) do
    Device.changeset(account, device, %{})
  end

  alias Ist.Recorder.Recording

  @doc """
  Returns the list of recordings.

  ## Examples

      iex> list_recordings(%Account{}, %Device{}, %{})
      [%Recording{}, ...]

  """
  def list_recordings(account, device, params) do
    Recording
    |> prefixed(account)
    |> where(device_id: ^device.id)
    |> order_by(desc: :started_at)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single recording.

  Raises `Ecto.NoResultsError` if the Recording does not exist.

  ## Examples

      iex> get_recording!(%Account{}, %Device{}, 123)
      %Recording{}

      iex> get_recording!(%Account{}, %Device{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_recording!(account, device, id) do
    Recording
    |> prefixed(account)
    |> where(device_id: ^device.id)
    |> Repo.get!(id)
  end

  @doc """
  Gets a single recording by UUID.

  Returns nil if the Recording does not exist.

  ## Examples

      iex> get_recording(%Account{}, %Device{}, "43caacd6-ccc4-439d-97db-4a4883e0eae5")
      %Recording{}

      iex> get_recording(%Account{}, %Device{}, "9c057527-4ac2-433b-9340-cbccc97dd8dd")
      nil

  """
  def get_recording(account, device, uuid) do
    Recording
    |> prefixed(account)
    |> where(device_id: ^device.id)
    |> Repo.get_by(uuid: uuid)
  end

  @doc """
  Creates a recording.

  ## Examples

      iex> create_recording(%Session{}, %{field: value})
      {:ok, %Recording{}}

      iex> create_recording(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recording(%Session{account: account, user: user}, attrs) do
    account
    |> Recording.changeset(%Recording{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Recording.

  ## Examples

      iex> delete_recording(%Session{}, recording)
      {:ok, %Recording{}}

      iex> delete_recording(%Session{}, recording)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recording(%Session{account: account, user: user}, %Recording{} = recording) do
    Trail.delete(recording, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recording changes.

  ## Examples

      iex> change_recording(%Account{}, recording)
      %Ecto.Changeset{source: %Recording{}}

  """
  def change_recording(%Account{} = account, %Recording{} = recording) do
    Recording.changeset(account, recording, %{})
  end
end
