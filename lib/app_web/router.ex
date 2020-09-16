defmodule AppWeb.Router do
  use AppWeb, :router

  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :app

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :guest do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :superuser do
    plug :is_superuser
  end

  pipeline :check_totp do
    plug AppWeb.TOTPPlug
  end

  pipeline :require_totp do
    plug AppWeb.Require2FAForUserPlug
    plug AppWeb.TOTPPlug
  end

  defp is_superuser(%{assigns: %{current_user: current_user}} = conn, _) do
    case current_user do
      nil  -> redir_and_halt(conn, to: AppWeb.PowRoutes.user_not_authenticated_path(conn))
      _user -> case current_user.superuser do
        true  -> conn
        false -> redir_and_halt(conn, to: AppWeb.PowRoutes.user_already_authenticated_path(conn))
      end
    end
  end
  defp is_superuser(conn, _), do: redir_and_halt(conn, to: AppWeb.PowRoutes.user_not_authenticated_path(conn))

  defp redir_and_halt(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> Plug.Conn.halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through :browser

    resources "/register-totp", TOTPRegistrationController, only: [:new, :create, :delete]
    resources "/totp-phase", TOTPVerificationController, only: [:new, :create]
  end

  scope "/" do
    pipe_through [:browser, :check_totp]

    pow_routes()
    pow_extension_routes()
    pow_assent_routes()
  end

  scope "/", AppWeb do
    pipe_through [:browser, :guest]

    # Add unprotected routes here
    get "/", PageController, :index
  end

  scope "/", AppWeb do
    pipe_through [:browser, :protected, :check_totp]

    # Add protected routes here
    get "/dashboard", DashController, :index
    resources "/teams", TeamController, except: [:index] do
      resources "/roles", MembershipController, except: [:index, :show]
    end
  end

  scope "/", AppWeb do
    pipe_through [:browser, :superuser, :require_totp]

    # Add superuser routes here
    get "/super", SuperController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end
end
