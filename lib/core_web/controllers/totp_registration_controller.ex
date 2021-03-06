defmodule CoreWeb.TOTPRegistrationController do
  use CoreWeb, :controller

  def new(conn, _params) do
    changeset = Pow.Plug.current_user(conn)

    case changeset.totp_secret do
      nil ->
        render(conn, "new.html", changeset: changeset |> Core.Accounts.User.add_totp_secret(), action: Routes.totp_registration_path(conn, :create))
      _else ->
        conn
        |> redirect(to: Routes.pow_registration_path(conn, :edit))
    end
  end

  def create(conn, %{"user" => params}) do
    user = conn
    |> Pow.Plug.current_user()
    |> Core.Accounts.User.totp_changeset(params)

    user
    |> Core.Accounts.User.valid_totp?(params)
    |> case do
      false -> redirect(conn, to: Routes.totp_registration_path(conn, :new))
      true ->
        user
        |> Core.Repo.update()
        |> case do
          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset, action: Routes.totp_registration_path(conn, :create))

          {:ok, user} ->
            conn
            |> CoreWeb.TOTPPlug.update_valid_totp_at_for_session(user)
            |> redirect(to: Routes.pow_registration_path(conn, :edit))
        end
    end
  end

  def delete(conn, _id, params) do
    delete(conn, params)
  end

  def delete(conn, _params) do
    user = Pow.Plug.current_user(conn)

    case user.totp_secret do
      nil ->
        conn
        |> redirect(to: Routes.pow_registration_path(conn, :edit))
      _else ->
        user
        |> Core.Accounts.User.totp_changeset(%{"totp_secret" => nil, "totp_backup" => []})
        |> Core.Repo.update()
        |> case do
          {:error, _changeset} ->
            conn
            |> put_flash(:error, "Sorry, coulden't disable TOTP. Please try again.")
            |> redirect(to: Routes.pow_registration_path(conn, :edit))

          {:ok, user} ->
            conn
            |> Pow.Plug.create(user)
            |> redirect(to: Routes.pow_registration_path(conn, :edit))
        end
    end
  end
end
