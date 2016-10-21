defmodule Logic do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Logic.CounterCoordinator, []),
      worker(Logic.TwitterWorker, [])
    ]

    opts = [strategy: :one_for_one, name: Logic.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
