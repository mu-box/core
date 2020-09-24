defmodule CoreWeb.Require2FAForUserPlug do
  @moduledoc """
  This plug ensures that a user has enabled 2FA.

  ## Example

      plug CoreWeb.Require2FAForUserPlug
  """

  alias CoreWeb.Router.Helpers, as: Routes

  @doc false
  @spec init(any()) :: any()
  def init(opts), do: opts

  @doc false
  @spec call(Conn.t(), any()) :: Conn.t()
  def call(conn, _opts) do
    conn
    |> Pow.Plug.current_user()
    |> case do
      nil  -> conn
      user -> maybe_require_2fa_registration(user, conn)
    end
  end

  defp maybe_require_2fa_registration(%{totp_secret: nil}, conn) do
    conn
    |> Phoenix.Controller.redirect(to: Routes.totp_registration_path(conn, :new))
    |> Plug.Conn.halt()
  end
  defp maybe_require_2fa_registration(_user, conn), do: conn
end
