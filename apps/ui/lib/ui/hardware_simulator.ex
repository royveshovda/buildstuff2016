defmodule Ui.HardwareSimulator do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([]) do
    Process.send_after(self(), :simulate_update, 1000)
    {:ok, %{}}
  end

  def handle_info(:simulate_update, state) do
    send_leds_update
    send_buttons_update
    send_sensor_update
    Process.send_after(self(), :simulate_update, 1000)
    {:noreply, state}
  end

  defp send_leds_update() do
    IO.puts "LEDs"
  end

  defp send_buttons_update() do
    IO.puts "Buttons"
  end

  defp send_sensor_update() do
    IO.puts "Sensorss"
  end
end
