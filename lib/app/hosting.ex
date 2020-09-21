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
end
