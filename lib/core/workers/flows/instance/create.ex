defmodule Core.Workers.Flows.Instance.Create do
  use Core.Workers.Flow

  @impl Core.Workers.Flow
  def build() do
    step Core.Workers.Steps.Server.Order, %{counter: 1, generation: 1}
    step Core.Workers.Steps.Server.WaitForReady
    step Core.Workers.Steps.Server.Bootstrap
    step Core.Workers.Steps.Server.PingAgent
    step Core.Workers.Flows.Platform.Create
    step Core.Workers.Steps.DNS.Update
    step Core.Workers.Steps.Portal.Configure
  end
end
