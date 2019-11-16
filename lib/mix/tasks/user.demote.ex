defmodule Mix.Tasks.User.Demote do
  use Mix.Task
  alias App.{Repo, Users.User}
  import Ecto.Query

  @shortdoc "Demotes a superuser to a normal user"

  @moduledoc """
    TODO
  """

  def run([]) do Mix.shell.info("Need an email for the user to demote.") end
  def run([email | _args]) do
    Mix.Task.run("app.start")
    case Repo.one(from u in User, where: u.email == ^email) do
      nil ->
        Mix.shell.info("User not found.")
      user ->
        case user |> Ecto.Changeset.change(superuser: false) |> Repo.update do
          {:ok, _struct} ->
            Mix.shell.info("Success!")
          {:error, _changeset} ->
            Mix.shell.info("Unable to commit demotion.")
        end
    end
  end
end
