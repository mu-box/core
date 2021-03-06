defmodule CoreWeb.API.UserController do
  use CoreWeb, :controller

  alias Core.Accounts

  action_fallback CoreWeb.FallbackController

  def token(conn, %{"slug" => username, "password" => password}) do
    case user = Accounts.get_user_by_name(username) do
      nil -> Argon2.no_user_verify()
      _else -> Argon2.verify_pass(password, user.password_hash)
    end
    |> case do
      true ->
        render(conn, "token.json", user: user)
      _else ->
        conn
        |> put_status(404)
        |> put_view(CoreWeb.APIView)
        |> render("error.json", message: "User not found with those credentials.")
    end
  end
  def token(conn, %{}) do
    Argon2.no_user_verify()
    conn
    |> put_status(400)
    |> put_view(CoreWeb.APIView)
    |> render("error.json", message: "Incomplete or missing credentials.")
  end

  def show(%{assigns: %{current_user: user}} = conn, _params) do
    render(conn, "user.json", user: user)
  end
end
