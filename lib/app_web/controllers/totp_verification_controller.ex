defmodule AppWeb.TOTPVerificationController do
  use AppWeb, :controller

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset, action: Routes.totp_verification_path(conn, :create))
  end

  def create(conn, %{"user" => params}) do
    conn
    |> Pow.Plug.current_user()
    |> App.Accounts.User.valid_totp?(params)
    |> case do
      false ->
        conn
        |> Pow.Plug.delete()
        |> put_flash(:error, "Sorry, invalid TOTP. Please try again.")
        |> redirect(to: Routes.pow_session_path(conn, :new))

      true ->
        user = Pow.Plug.current_user(conn)

        user
        |> App.Accounts.User.last_totp_changeset(%{last_totp: params["totp"]})
        |> App.Repo.update()
        |> case do
          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset, action: Routes.totp_verification_path(conn, :create))

          {:ok, user} ->
            conn
            |> AppWeb.TOTPPlug.update_valid_totp_at_for_session(user)
            |> redirect(to: Routes.page_path(conn, :index))
        end
    end
  end
end
