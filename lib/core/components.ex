defmodule Core.Components do
  @moduledoc """
  The Components context.
  """

  import Ecto.Query, warn: false
  alias Core.Repo

  alias Core.Components.Component

  @doc """
  Returns the list of components.

  ## Examples

      iex> list_components()
      [%Component{}, ...]

  """
  def list_components do
    Repo.all(Component)
  end

  @doc """
  Gets a single component.

  Raises `Ecto.NoResultsError` if the Component does not exist.

  ## Examples

      iex> get_component!(123)
      %Component{}

      iex> get_component!(456)
      ** (Ecto.NoResultsError)

  """
  def get_component!(id), do: Repo.get!(Component, id)

  @doc """
  Gets a single component based on the service and name.

  Raises `Ecto.NoResultsError` if the Component does not exist.

  ## Examples

      iex> get_component_by_service_and_name(123)
      %Component{}

  """
  def get_component_by_service_and_name(service_id, name), do: Repo.get_by(Component, %{service_id: service_id, name: name})

  @doc """
  Gets a single component based on the instance and name.

  Raises `Ecto.NoResultsError` if the Component does not exist.

  ## Examples

      iex> get_component_by_instance_and_name(123)
      %Component{}

  """
  def get_component_by_instance_and_name(instance_id, name), do: Repo.get_by(Component, %{instance_id: instance_id, name: name})

  @doc """
  Creates a component.

  ## Examples

      iex> create_component(%{field: value})
      {:ok, %Component{}}

      iex> create_component(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_component(attrs \\ %{}) do
    %Component{}
    |> Component.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a component.

  ## Examples

      iex> update_component(component, %{field: new_value})
      {:ok, %Component{}}

      iex> update_component(component, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_component(%Component{} = component, attrs) do
    component
    |> Component.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a component.

  ## Examples

      iex> delete_component(component)
      {:ok, %Component{}}

      iex> delete_component(component)
      {:error, %Ecto.Changeset{}}

  """
  def delete_component(%Component{} = component) do
    Repo.delete(component)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking component changes.

  ## Examples

      iex> change_component(component)
      %Ecto.Changeset{source: %Component{}}

  """
  def change_component(%Component{} = component) do
    Component.changeset(component, %{})
  end

  alias Core.Components.Generation

  @doc """
  Returns the list of component_generations.

  ## Examples

      iex> list_component_generations()
      [%Generation{}, ...]

  """
  def list_component_generations do
    Repo.all(Generation)
  end

  @doc """
  Gets a single generation.

  Raises `Ecto.NoResultsError` if the Generation does not exist.

  ## Examples

      iex> get_generation!(123)
      %Generation{}

      iex> get_generation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_generation!(id), do: Repo.get!(Generation, id)

  @doc """
  Gets a single generation by component and number.

  ## Examples

      iex> get_generation!(123)
      %Generation{}

  """
  def get_generation_by_component_and_counter(component_id, counter), do: Repo.get_by(Generation, %{component_id: component_id, counter: counter})

  @doc """
  Creates a generation.

  ## Examples

      iex> create_generation(%{field: value})
      {:ok, %Generation{}}

      iex> create_generation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_generation(attrs \\ %{}) do
    %Generation{}
    |> Generation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a generation.

  ## Examples

      iex> update_generation(generation, %{field: new_value})
      {:ok, %Generation{}}

      iex> update_generation(generation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_generation(%Generation{} = generation, attrs) do
    generation
    |> Generation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a generation.

  ## Examples

      iex> delete_generation(generation)
      {:ok, %Generation{}}

      iex> delete_generation(generation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_generation(%Generation{} = generation) do
    Repo.delete(generation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking generation changes.

  ## Examples

      iex> change_generation(generation)
      %Ecto.Changeset{source: %Generation{}}

  """
  def change_generation(%Generation{} = generation) do
    Generation.changeset(generation, %{})
  end

  alias Core.Components.Member

  @doc """
  Returns the list of component_members.

  ## Examples

      iex> list_component_members()
      [%Member{}, ...]

  """
  def list_component_members do
    Repo.all(Member)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: Repo.get!(Member, id)

  @doc """
  Gets a single member by generation and counter.

  ## Examples

      iex> get_member_by_generation_and_counter(123)
      %Member{}

  """
  def get_member_by_generation_and_counter(generation_id, counter), do: Repo.get_by(Member, %{generation_id: generation_id, counter: counter})

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end

  alias Core.Components.Server

  @doc """
  Returns the list of component_servers.

  ## Examples

      iex> list_component_servers()
      [%Server{}, ...]

  """
  def list_component_servers do
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
  Gets a single server relationship by server and component member ids.

  ## Examples

      iex> get_server_by_ids(123, 456)
      %Server{}

  """
  def get_server_by_ids(server_id, member_id), do: Repo.get_by(Server, %{server_id: server_id, member_id: member_id})

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
end
