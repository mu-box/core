defmodule Core.Workers.Flows.Platform.Create do
  use Core.Workers.Flow

  @impl Core.Workers.Flow
  def build() do
    for service <- ["portal", "mist", "logvac", "pulse", "hoarder"] do
      step Core.Workers.Steps.Platform.InstallImage, %{service: service}
      step Core.Workers.Steps.Platform.CreateContainer, %{service: service}
      step Core.Workers.Steps.Platform.Configure, %{service: service}
      step Core.Workers.Steps.Platform.Start
    end
  end
end
