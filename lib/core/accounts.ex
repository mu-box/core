defmodule Core.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Core.Repo

  alias Core.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(from u in User, where: u.superuser == false, preload: [:hosting_accounts, :hosting_adapters, :teams])
  end

  @doc """
  Returns the list of superusers.

  ## Examples

      iex> super_users()
      [%User{}, ...]

  """
  def super_users do
    Repo.all(from u in User, where: u.superuser == true, preload: [:hosting_accounts, :hosting_adapters, :teams])
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload([:hosting_accounts, :hosting_adapters, :teams])

  @doc """
  Gets a single user by its name.

  Raises if the User does not exist.

  ## Examples

      iex> get_user_by_name!("hennikhunsaker")
      %User{username: "hennikhunsaker"}

  """
  def get_user_by_name!(name), do: Repo.get_by!(User, [username: name])

  @doc """
  Gets a single user by its name.

  ## Examples

      iex> get_user_by_name("hennikhunsaker")
      %User{username: "hennikhunsaker"}

  """
  def get_user_by_name(name), do: Repo.get_by(User, [username: name])

  @doc """
  Gets a single user by its auth_token.

  Raises if the User does not exist.

  ## Examples

  iex> get_user_by_auth_token!("MDAwMDAwMDAwMDAwMDA")
  %User{authentication_token: "MDAwMDAwMDAwMDAwMDA"}

  """
  def get_user_by_auth_token!(auth_token), do: Repo.get_by!(User, [authentication_token: auth_token])

  @doc """
  Gets a single user by its auth_token.

  ## Examples

  iex> get_user_by_auth_token("MDAwMDAwMDAwMDAwMDA")
  %User{authentication_token: "MDAwMDAwMDAwMDAwMDA"}

  """
  def get_user_by_auth_token(auth_token), do: Repo.get_by(User, [authentication_token: auth_token])

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Core.Accounts.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Gets a single team by its slug.

  Raises if the Team does not exist.

  ## Examples

      iex> get_team_by_slug!("foo")
      %Team{}

  """
  def get_team_by_slug!(slug), do: Repo.get_by!(Team, [slug: slug])

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, ...}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, ...}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, ...}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns a data structure for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Todo{...}

  """
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end

  alias Core.Accounts.TeamMembership

  @doc """
  Returns the list of team_memberships.

  ## Examples

      iex> list_team_memberships()
      [%TeamMembership{}, ...]

  """
  def list_team_memberships do
    Repo.all(TeamMembership)
  end

  @doc """
  Gets a single team_membership.

  Raises if the TeamMembership does not exist.

  ## Examples

      iex> get_team_membership!(123)
      %TeamMembership{}

  """
  def get_team_membership!(id), do: Repo.get!(TeamMembership, id)

  @doc """
  Creates a team_membership.

  ## Examples

      iex> create_team_membership(%{field: value})
      {:ok, %TeamMembership{}}

      iex> create_team_membership(%{field: bad_value})
      {:error, ...}

  """
  def create_team_membership(attrs \\ %{}) do
    %TeamMembership{}
    |> TeamMembership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_membership.

  ## Examples

      iex> update_team_membership(team_membership, %{field: new_value})
      {:ok, %TeamMembership{}}

      iex> update_team_membership(team_membership, %{field: bad_value})
      {:error, ...}

  """
  def update_team_membership(%TeamMembership{} = team_membership, attrs) do
    team_membership
    |> TeamMembership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TeamMembership.

  ## Examples

      iex> delete_team_membership(team_membership)
      {:ok, %TeamMembership{}}

      iex> delete_team_membership(team_membership)
      {:error, ...}

  """
  def delete_team_membership(%TeamMembership{} = team_membership) do
    Repo.delete(team_membership)
  end

  @doc """
  Returns a data structure for tracking team_membership changes.

  ## Examples

      iex> change_team_membership(team_membership)
      %Todo{...}

  """
  def change_team_membership(%TeamMembership{} = team_membership) do
    TeamMembership.changeset(team_membership, %{})
  end

  alias Core.Accounts.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Gets a single role by its name.

  Raises if the Role does not exist.

  ## Examples

      iex> get_role_by_name!("Owner")
      %Role{name: "Owner"}

  """
  def get_role_by_name!(name), do: Repo.get_by!(Role, [name: name])

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, ...}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, ...}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, ...}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns a data structure for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Todo{...}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  @doc """
  Returns a boolean indicating whether the user has the requested team permission
  """
  def can_access_team(user, team, permission, want) do
    user = user |> Repo.preload([:memberships])
    team_id = team.id
    case user.superuser do
      true -> true
      false ->
        Enum.find(user.memberships, nil, fn (membership) ->
          case membership do
            %{team_id: ^team_id} -> true
            _else -> false
          end
        end)
        |> case do
          %TeamMembership{} = membership ->
            membership
            |> Repo.preload([:role])
            |> case do
              %TeamMembership{role: %Role{permissions: %{^permission => have}}} ->
                case want do
                  "admin" ->
                    case have do
                      "admin" -> true
                      _else -> false
                    end
                  "write" ->
                    case have do
                      "admin" -> true
                      "write" -> true
                      _else -> false
                    end
                  "read" ->
                    case have do
                      "admin" -> true
                      "write" -> true
                      "read" -> true
                      _else -> false
                    end
                  "any" -> true
                  _else -> false
                end
              _else -> false
            end
          _else -> false
        end
    end
  end

  alias Core.Applications.InstanceAccess

  @doc """
  Returns a boolean indicating whether the user has the requested instance permission
  """
  def can_access_instance(user, instance, permission, want) do
    instance = instance |> Core.Repo.preload([app: [:team]])
    case can_access_team(user, instance.app.team, permission, want) do
      true -> true
      false ->
        user = user |> Repo.preload([:access])
        instance_id = instance.id
        case user.superuser do
          true -> true
          false ->
            Enum.find(user.access, nil, fn (access) ->
              case access do
                %{instance_id: ^instance_id} -> true
                _else -> false
              end
            end)
            |> case do
              %InstanceAccess{} = access ->
                access
                |> Repo.preload([:role])
                |> case do
                  %InstanceAccess{role: %Role{permissions: %{^permission => have}}} ->
                    case want do
                      "admin" ->
                        case have do
                          "admin" -> true
                          _else -> false
                        end
                      "write" ->
                        case have do
                          "admin" -> true
                          "write" -> true
                          _else -> false
                        end
                      "read" ->
                        case have do
                          "admin" -> true
                          "write" -> true
                          "read" -> true
                          _else -> false
                        end
                      "any" -> true
                      _else -> false
                    end
                  _else -> false
                end
              _else -> false
            end
        end
    end
  end
end
