defmodule Mix.Tasks.User.Promote do
  use Mix.Task
  alias Core.{Repo, Accounts.User}
  import Ecto.Query

  @shortdoc "Promotes a user to a superuser"

  @moduledoc """
    TODO
  """

  def run([]) do Mix.shell.info("Need a username for the user to promote.") end
  def run([username | _args]) do
    Mix.Task.run("app.start")
    case Repo.one(from u in User, where: u.username == ^username) do
      nil ->
        Mix.shell.info("User not found.")
      user ->
        case user |> Ecto.Changeset.change(superuser: true) |> Repo.update do
          {:ok, _struct} ->
            Mix.shell.info("Success!")
          {:error, _changeset} ->
            Mix.shell.info("Unable to commit promotion.")
        end
    end
  end
end
