defmodule Ui.HardwareSimulator do
  use GenServer

  def start() do
    start_link()
    Ui.Simulator.Led.start_link()
    Ui.Simulator.Sensor.start_link()  
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([]) do
    Process.send_after(self(), :simulate_update, 500)
    {:ok, %{}}
  end

  def handle_info(:simulate_update, state) do
    Ui.Simulator.Led.set_random_values()
    send_buttons_update
    Ui.Simulator.Sensor.set_random_values()
    Process.send_after(self(), :simulate_update, 5000)
    {:noreply, state}
  end

  defp send_buttons_update() do
    b1 = Enum.random([0,1])
    b2 = Enum.random([0,1])
    Ui.Updater.send_buttons_update(%{temperature_button: b1, humidity_button: b2})
  end
end
