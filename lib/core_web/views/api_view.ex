defmodule CoreWeb.APIView do
  use CoreWeb, :view
  # alias CoreWeb.APIView

  def render("error.json", %{message: message}) do
    %{errors: [message]}
  end

  def render("version.json", %{version: version}) do
    %{name: "Microbox API", version: version}
  end
end
