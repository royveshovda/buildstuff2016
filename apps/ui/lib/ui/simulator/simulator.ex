defmodule Ui.Simulator do
  use GenServer

  ## Client API
  def start() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
    Ui.Simulator.Led.start_link()
    Ui.Simulator.Sensor.start_link()
    Ui.Simulator.Button.start_link()
  end

  ## Server API
  def init([]) do
    Process.send_after(self(), :simulate_update, 500)
    {:ok, %{}}
  end

  def handle_info(:simulate_update, state) do
    Ui.Simulator.Led.set_random_values()
    Ui.Simulator.Button.set_random_values()
    Ui.Simulator.Sensor.set_random_values()
    Process.send_after(self(), :simulate_update, 5000)
    {:noreply, state}
  end
end
