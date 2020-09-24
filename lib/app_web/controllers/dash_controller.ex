defmodule AppWeb.DashController do
  use AppWeb, :controller

  def index(conn, _params) do
    render conn, "index.html",
      current_user:
        Pow.Plug.current_user(conn)
        |> App.Repo.preload([:teams, :hosting_adapters, :hosting_accounts]),
      global_adapters: App.Hosting.global_adapters()
  end

  def regenerate_token(%{assigns: %{current_user: user}} = conn, _params) do
    user
    |> App.Accounts.User.add_auth_token()
    |> App.Repo.update()
    |> case do
      {:ok, user} ->
        conn
        |> Pow.Plug.create(user)
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Regeneration failed. Try again!")
    end
    |> redirect(to: Routes.pow_registration_path(conn, :edit))
  end
end
