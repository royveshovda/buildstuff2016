defmodule Fw do
  use Application
  alias Nerves.InterimWiFi, as: WiFi

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Task, [fn -> network end], restart: :transient),
      worker(Fw.Led, []),
      worker(Fw.Sensor, []),
      worker(Fw.Button, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def network do
    wlan_config = Application.get_env(:fw, :wlan0)
    WiFi.setup "wlan0", wlan_config
  end

end
