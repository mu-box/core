defmodule App.Hosting do
  @moduledoc """
  The Hosting context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Hosting.Adapter

  @doc """
  Returns the list of adapters.

  ## Examples

      iex> list_adapters()
      [%Adapter{}, ...]

  """
  def list_adapters do
    Repo.all(Adapter)
  end

  @doc """
  Returns the list of global adapters.

  ## Examples

      iex> global_adapters()
      [%Adapter{}, ...]

  """
  def global_adapters do
    Repo.all(from a in Adapter, where: a.global == true)
  end

  @doc """
  Gets a single adapter.

  Raises `Ecto.NoResultsError` if the Adapter does not exist.

  ## Examples

      iex> get_adapter!(123)
      %Adapter{}

      iex> get_adapter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_adapter!(id), do: Repo.get!(Adapter, id)

  @doc """
  Creates a adapter.

  ## Examples

      iex> create_adapter(%{field: value})
      {:ok, %Adapter{}}

      iex> create_adapter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_adapter(attrs \\ %{}) do
    %Adapter{}
    |> Adapter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a adapter.

  ## Examples

      iex> update_adapter(adapter, %{field: new_value})
      {:ok, %Adapter{}}

      iex> update_adapter(adapter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_adapter(%Adapter{} = adapter, attrs) do
    adapter
    |> Adapter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a adapter.

  ## Examples

      iex> delete_adapter(adapter)
      {:ok, %Adapter{}}

      iex> delete_adapter(adapter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_adapter(%Adapter{} = adapter) do
    adapter
    |> Adapter.changeset(%{})
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking adapter changes.

  ## Examples

      iex> change_adapter(adapter)
      %Ecto.Changeset{source: %Adapter{}}

  """
  def change_adapter(%Adapter{} = adapter) do
    Adapter.changeset(adapter, %{})
  end

  alias App.Hosting.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    account
    |> Account.changeset(%{})
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  @doc """
  Checks the supplied credentials against the given adapter to see if they're correct.
  """
  def try_creds(%Adapter{} = adapter, %{} = creds) do
    headers = Map.keys(creds)
    |> Enum.map(fn (key) -> {"Auth-" <> key |> String.split(~r/[_-]/) |> Enum.map(&String.capitalize(&1)) |> Enum.join("-"), Map.get(creds, key)} end)
    case HTTPoison.post(adapter.endpoint <> "/verify", "", headers) do
      {:ok, %{status_code: 200}} -> true
      other ->
        IO.inspect(other)
        false
    end
  end
end
