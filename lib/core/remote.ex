defmodule Core.Remote do
  @moduledoc """
  The Remote context.
  """

  import Ecto.Query, warn: false
  alias Core.Repo

  alias Core.Remote.Server

  @doc """
  Returns the list of servers.

  ## Examples

      iex> list_servers()
      [%Server{}, ...]

  """
  def list_servers do
    Repo.all(Server)
  end

  @doc """
  Gets a single server.

  Raises `Ecto.NoResultsError` if the Server does not exist.

  ## Examples

      iex> get_server!(123)
      %Server{}

      iex> get_server!(456)
      ** (Ecto.NoResultsError)

  """
  def get_server!(id), do: Repo.get!(Server, id)

  @doc """
  Gets a single server by name.

  Raises `Ecto.NoResultsError` if the Server does not exist.

  ## Examples

      iex> get_server_by_name!("name")
      %Server{}

      iex> get_server_by_name!("invalid name")
      ** (Ecto.NoResultsError)

  """
  def get_server_by_name!(name), do: Repo.get_by!(Server, [name: name])

  @doc """
  Creates a server.

  ## Examples

      iex> create_server(%{field: value})
      {:ok, %Server{}}

      iex> create_server(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a server.

  ## Examples

      iex> update_server(server, %{field: new_value})
      {:ok, %Server{}}

      iex> update_server(server, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_server(%Server{} = server, attrs) do
    server
    |> Server.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a server.

  ## Examples

      iex> delete_server(server)
      {:ok, %Server{}}

      iex> delete_server(server)
      {:error, %Ecto.Changeset{}}

  """
  def delete_server(%Server{} = server) do
    Repo.delete(server)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking server changes.

  ## Examples

      iex> change_server(server)
      %Ecto.Changeset{source: %Server{}}

  """
  def change_server(%Server{} = server) do
    Server.changeset(server, %{})
  end

  alias Core.Remote.Key

  @doc """
  Returns the list of keys.

  ## Examples

      iex> list_keys()
      [%Key{}, ...]

  """
  def list_keys do
    Repo.all(Key)
  end

  @doc """
  Gets a single key.

  Raises `Ecto.NoResultsError` if the Key does not exist.

  ## Examples

      iex> get_key!(123)
      %Key{}

      iex> get_key!(456)
      ** (Ecto.NoResultsError)

  """
  def get_key!(id), do: Repo.get!(Key, id)

  @doc """
  Creates a key.

  ## Examples

      iex> create_key(%{field: value})
      {:ok, %Key{}}

      iex> create_key(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_key(attrs \\ %{}) do
    %Key{}
    |> Key.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Generates a keypair and returns it as a map ready for create_key/1

  ## Example

      iex> generate_key_attrs(title)
      %{title: title, public: public_key, private: private_key}

  """
  def generate_key_attrs(title) do
    if Core.KeyManager.generate_keys(title) do
      public = Core.KeyManager.public_key(title)
      private = Core.KeyManager.private_key(title)
      Core.KeyManager.remove_keys(title)

      %{title: title, public: public, private: private}
    else
      %{title: title}
    end
  end

  @doc """
  Updates a key.

  ## Examples

      iex> update_key(key, %{field: new_value})
      {:ok, %Key{}}

      iex> update_key(key, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_key(%Key{} = key, attrs) do
    key
    |> Key.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a key.

  ## Examples

      iex> delete_key(key)
      {:ok, %Key{}}

      iex> delete_key(key)
      {:error, %Ecto.Changeset{}}

  """
  def delete_key(%Key{} = key) do
    Repo.delete(key)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking key changes.

  ## Examples

      iex> change_key(key)
      %Ecto.Changeset{source: %Key{}}

  """
  def change_key(%Key{} = key) do
    Key.changeset(key, %{})
  end
end
