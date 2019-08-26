defmodule AppWeb.PowRoutes do
  use Pow.Phoenix.Routes
  alias AppWeb.Router.Helpers, as: Routes

  def user_not_authenticated_path(conn), do: Routes.pow_session_path(conn, :new)
  def user_already_authenticated_path(conn), do: Routes.pow_registration_path(conn, :edit) # TODO: Update to dashboard page, once built
  def after_sign_out_path(conn), do: Routes.page_path(conn, :index)
  def after_sign_in_path(conn), do: Routes.pow_registration_path(conn, :edit) # TODO: Update to dashboard page, once built
  def after_registration_path(conn), do: Routes.pow_registration_path(conn, :edit)
  def after_user_updated_path(conn), do: Routes.pow_registration_path(conn, :edit) # TODO: Update to dashboard page, once built
  def after_user_deleted_path(conn), do: Routes.page_path(conn, :index)
end
