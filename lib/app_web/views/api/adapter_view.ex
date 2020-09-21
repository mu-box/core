defmodule AppWeb.API.AdapterView do
  use AppWeb, :view
  alias AppWeb.API.AdapterView

  def render("adapter.json", %{adapter: adapter}) do
    %{unlink_code: adapter.unlink_code}
  end
end
