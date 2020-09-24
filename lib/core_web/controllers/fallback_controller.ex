defmodule CoreWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CoreWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CoreWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %{errors: _errors} = changeset}) do
    conn
    |> put_status(:conflict)
    |> put_view(CoreWeb.ChangesetView)
    |> render("error.json", %{changeset: changeset})
  end
end
