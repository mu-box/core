defmodule CoreWeb.API.AdapterView do
  use CoreWeb, :view
  alias CoreWeb.API.AdapterView

  def render("adapter.json", %{adapter: adapter}) do
    %{unlink_code: adapter.unlink_code}
  end
end
