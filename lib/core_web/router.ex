defmodule CoreWeb.Router do
  use CoreWeb, :router

  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :core

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
    plug CoreWeb.TOTPPlug
  end

  pipeline :require_totp do
    plug CoreWeb.Require2FAForUserPlug
    plug CoreWeb.TOTPPlug
  end

  defp is_superuser(%{assigns: %{current_user: current_user}} = conn, _) do
    case current_user do
      nil  -> redir_and_halt(conn, to: CoreWeb.PowRoutes.user_not_authenticated_path(conn))
      _user -> case current_user.superuser do
        true  -> conn
        false -> redir_and_halt(conn, to: CoreWeb.PowRoutes.user_already_authenticated_path(conn))
      end
    end
  end
  defp is_superuser(conn, _), do: redir_and_halt(conn, to: CoreWeb.PowRoutes.user_not_authenticated_path(conn))

  defp redir_and_halt(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> Plug.Conn.halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :need_auth_token do
    plug :check_auth_token
  end

  defp check_auth_token(conn, _) do
    conn
    |> get_req_header("x-auth-token")
    |> List.first()
    |> case do
      nil -> error_and_halt(conn, 401, "User not provided")
      token ->
        case Core.Accounts.get_user_by_auth_token(token) do
          nil -> error_and_halt(conn, 401, "User not found")
          user -> conn |> assign(:current_user, user)
        end
    end
  end

  defp error_and_halt(conn, code, message) do
    conn
    |> put_status(code)
    |> put_view(CoreWeb.APIView)
    |> render("error.json", message: message)
    |> Plug.Conn.halt()
  end

  scope "/", CoreWeb do
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

  scope "/", CoreWeb do
    pipe_through [:browser, :guest]

    # Add unprotected routes here
    get "/", PageController, :index
  end

  scope "/", CoreWeb do
    pipe_through [:browser, :protected, :check_totp]

    # Add protected routes here
    get "/dashboard", DashController, :index
    put "/dashboard/regen_token", DashController, :regenerate_token
    resources "/teams", TeamController, except: [:index] do
      resources "/roles", MembershipController, except: [:index, :show]
      resources "/accounts", AccountController, except: [:index] do
        get "/creds/new", AccountController, :new_creds
        post "/creds", AccountController, :create_creds
        get "/creds/edit", AccountController, :edit_creds
        put "/creds", AccountController, :update_creds
      end
    end
    resources "/adapters", AdapterController, only: [:create] do
      get "/share", AdapterController, :share_form
      post "/share", AdapterController, :share
      get "/unshare", AdapterController, :unshare_form
      post "/unshare", AdapterController, :unshare
    end
    resources "/accounts", AccountController, except: [:index] do
      get "/creds/new", AccountController, :new_creds
      post "/creds", AccountController, :create_creds
      get "/creds/edit", AccountController, :edit_creds
      put "/creds", AccountController, :update_creds
    end
  end

  scope "/super", CoreWeb do
    pipe_through [:browser, :superuser, :require_totp]

    # Add superuser routes here
    get "/", SuperController, :index
    post "/adapter/:adapter_id", SuperController, :make_global
    delete "/adapter/:adapter_id", SuperController, :make_local
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", CoreWeb.API do
    pipe_through :api

    get "/", MiscController, :version
    get "/user_auth_token", UserController, :token
    get "/users/:slug/auth_token", UserController, :token
  end

  scope "/api/v1", CoreWeb.API do
    pipe_through [:api, :need_auth_token]

    get "/users/:me", UserController, :show
    post "/adapters/:id", AdapterController, :register
    delete "/adapters/:id", AdapterController, :unregister
  end
end
