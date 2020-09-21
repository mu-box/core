defmodule AppWeb.AdapterController do
  use AppWeb, :controller

  alias App.Hosting

  def create(conn, %{"user_id" => user_id}) do
    case Hosting.create_adapter(%{"user_id" => user_id}) do
      {:ok, _adapter} ->
        conn
        |> put_flash(:info, "Adapter created successfully.")
        |> redirect(to: Routes.dash_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
