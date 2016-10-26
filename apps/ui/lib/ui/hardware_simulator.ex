defmodule Ui.HardwareSimulator do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([]) do
    Process.send_after(self(), :simulate_update, 500)
    {:ok, %{}}
  end

  def handle_info(:simulate_update, state) do
    send_leds_update
    send_buttons_update
    send_sensor_update
    Process.send_after(self(), :simulate_update, 5000)
    {:noreply, state}
  end

  defp send_leds_update() do
    g1 = Enum.random([0,1])
    g2 = Enum.random([0,1])
    y1 = Enum.random([0,1])
    y2 = Enum.random([0,1])
    r1 = Enum.random([0,1])
    r2 = Enum.random([0,1])
    Ui.Updater.send_leds_update(%{g1: g1, g2: g2, y1: y1, y2: y2, r1: r1, r2: r2})
  end

  defp send_buttons_update() do
    b1 = Enum.random([0,1])
    b2 = Enum.random([0,1])
    Ui.Updater.send_buttons_update(%{temperature_button: b1, humidity_button: b2})
  end

  defp send_sensor_update() do
    temperature = :rand.uniform * 10 + 20
    humidity = :rand.uniform * 10 + 40
    Ui.Updater.send_sensor_update(%{temperature: temperature, humidity: humidity})
  end
end
