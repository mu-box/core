defmodule Core.Applications do
  @moduledoc """
  The Applications context.
  """

  import Ecto.Query, warn: false
  alias Core.Repo

  alias Core.Applications.App
  alias Core.Applications.Instance

  @doc """
  Returns the list of apps.

  ## Examples

      iex> list_apps()
      [%App{}, ...]

  """
  def list_apps do
    Repo.all(App)
  end

  @doc """
  Gets a single app.

  Raises `Ecto.NoResultsError` if the App does not exist.

  ## Examples

      iex> get_app!(123)
      %App{}

      iex> get_app!(456)
      ** (Ecto.NoResultsError)

  """
  def get_app!(id), do: Repo.get!(App, id)

  @doc """
  Gets a single app.

  ## Examples

      iex> get_app(123)
      %App{}

      iex> get_app(456)
      nil

  """
  def get_app(id), do: Repo.get(App, id)

  @doc """
  Gets a single app by user and name.

  Raises `Ecto.NoResultsError` if the App does not exist.

  ## Examples

      iex> get_app_by_user_and_name!(user, "foo")
      %App{}

      iex> get_app_by_user_and_name!(user, "bar")
      ** (Ecto.NoResultsError)

  """
  def get_app_by_user_and_name!(user, name), do: Repo.get_by!(App, [user_id: user.id, name: name])

  @doc """
  Gets a single app by team and name.

  Raises `Ecto.NoResultsError` if the App does not exist.

  ## Examples

      iex> get_app_by_team_and_name!(team, "foo")
      %App{}

      iex> get_app_by_team_and_name!(team, "bar")
      ** (Ecto.NoResultsError)

  """
  def get_app_by_team_and_name!(team, name), do: Repo.get_by!(App, [team_id: team.id, name: name])

  @doc """
  Creates a app.

  ## Examples

      iex> create_app(%{field: value})
      {:ok, %App{}}

      iex> create_app(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_app(attrs \\ %{}) do
    %App{}
    |> App.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %App{} = app} ->
        case create_instance(%{app_id: app.id}) do
          {:ok, %Instance{}} -> {:ok, app}
          err -> err
        end
      err ->
        err
    end
  end

  @doc """
  Updates a app.

  ## Examples

      iex> update_app(app, %{field: new_value})
      {:ok, %App{}}

      iex> update_app(app, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_app(%App{} = app, attrs) do
    app
    |> App.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a app.

  ## Examples

      iex> delete_app(app)
      {:ok, %App{}}

      iex> delete_app(app)
      {:error, %Ecto.Changeset{}}

  """
  def delete_app(%App{} = app) do
    Repo.delete(app)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking app changes.

  ## Examples

      iex> change_app(app)
      %Ecto.Changeset{source: %App{}}

  """
  def change_app(%App{} = app) do
    App.changeset(app, %{})
  end

  @doc """
  Returns the list of instances.

  ## Examples

      iex> list_instances()
      [%Instance{}, ...]

  """
  def list_instances do
    Repo.all(Instance)
  end

  @doc """
  Gets a single instance.

  Raises `Ecto.NoResultsError` if the Instance does not exist.

  ## Examples

      iex> get_instance!(123)
      %Instance{}

      iex> get_instance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_instance!(id), do: Repo.get!(Instance, id)

  @doc """
  Creates a instance.

  ## Examples

      iex> create_instance(%{field: value})
      {:ok, %Instance{}}

      iex> create_instance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_instance(attrs \\ %{}) do
    %Instance{}
    |> Instance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a instance.

  ## Examples

      iex> update_instance(instance, %{field: new_value})
      {:ok, %Instance{}}

      iex> update_instance(instance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_instance(%Instance{} = instance, attrs) do
    instance
    |> Instance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a instance.

  ## Examples

      iex> delete_instance(instance)
      {:ok, %Instance{}}

      iex> delete_instance(instance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_instance(%Instance{} = instance) do
    Repo.preload(instance, [:access]) |> Map.get(:access) |> Enum.each(fn (access) -> Repo.delete(access) end)
    Repo.delete(instance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking instance changes.

  ## Examples

      iex> change_instance(instance)
      %Ecto.Changeset{source: %Instance{}}

  """
  def change_instance(%Instance{} = instance) do
    Instance.changeset(instance, %{})
  end

  alias Core.Applications.InstanceAccess

  @doc """
  Returns the list of instance_access.

  ## Examples

      iex> list_instance_access()
      [%InstanceAccess{}, ...]

  """
  def list_instance_access do
    Repo.all(InstanceAccess)
  end

  @doc """
  Gets a single instance_access.

  Raises if the Instance access does not exist.

  ## Examples

      iex> get_instance_access!(123)
      %InstanceAccess{}

  """
  def get_instance_access!(id), do: Repo.get!(InstanceAccess, id)

  @doc """
  Creates a instance_access.

  ## Examples

      iex> create_instance_access(%{field: value})
      {:ok, %InstanceAccess{}}

      iex> create_instance_access(%{field: bad_value})
      {:error, ...}

  """
  def create_instance_access(attrs \\ %{}) do
    %InstanceAccess{}
    |> InstanceAccess.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a instance_access.

  ## Examples

      iex> update_instance_access(instance_access, %{field: new_value})
      {:ok, %InstanceAccess{}}

      iex> update_instance_access(instance_access, %{field: bad_value})
      {:error, ...}

  """
  def update_instance_access(%InstanceAccess{} = instance_access, attrs) do
    instance_access
    |> InstanceAccess.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a InstanceAccess.

  ## Examples

      iex> delete_instance_access(instance_access)
      {:ok, %InstanceAccess{}}

      iex> delete_instance_access(instance_access)
      {:error, ...}

  """
  def delete_instance_access(%InstanceAccess{} = instance_access) do
    Repo.delete(instance_access)
  end

  @doc """
  Returns a data structure for tracking instance_access changes.

  ## Examples

      iex> change_instance_access(instance_access)
      %Todo{...}

  """
  def change_instance_access(%InstanceAccess{} = instance_access) do
    InstanceAccess.changeset(instance_access, %{})
  end

  alias Core.Applications.Service

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services()
      [%Service{}, ...]

  """
  def list_services do
    Repo.all(Service)
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(123)
      %Service{}

      iex> get_service!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(id), do: Repo.get!(Service, id)

  @doc """
  Gets a single service by instance ID and slug.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service_by_instance_and_slug!(123, "exists")
      %Service{}

      iex> get_service_by_instance_and_slug!(456, "invalid")
      ** (Ecto.NoResultsError)

  """
  def get_service_by_instance_and_slug(instance_id, slug), do: Repo.get_by(Service, %{instance_id: instance_id, slug: slug})

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(%{field: value})
      {:ok, %Service{}}

      iex> create_service(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(attrs \\ %{}) do
    %Service{}
    |> Service.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a service.

  ## Examples

      iex> update_service(service, %{field: new_value})
      {:ok, %Service{}}

      iex> update_service(service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service(%Service{} = service, attrs) do
    service
    |> Service.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a service.

  ## Examples

      iex> delete_service(service)
      {:ok, %Service{}}

      iex> delete_service(service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(service)
      %Ecto.Changeset{source: %Service{}}

  """
  def change_service(%Service{} = service) do
    Service.changeset(service, %{})
  end
end
