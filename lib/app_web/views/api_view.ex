defmodule AppWeb.APIView do
  use AppWeb, :view
  # alias AppWeb.APIView

  def render("error.json", %{message: message}) do
    %{errors: [message]}
  end

  def render("version.json", %{version: version}) do
    version
  end
end
