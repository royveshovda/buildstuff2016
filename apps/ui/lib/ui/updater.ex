defmodule Ui.Updater do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def send_leds_update(led_states) do
    GenServer.cast(__MODULE__, {:leds, led_states})
  end

  def send_buttons_update(button_states) do
    GenServer.cast(__MODULE__, {:buttons, button_states})
  end

  def send_sensor_update(sensor_states) do
    GenServer.cast(__MODULE__, {:sensors, sensor_states})
  end

  def handle_cast({:leds, led_states}, state) do
    message = "LEDs: #{inspect led_states}"
    Ui.HardwareChannel.broadcast_update(message)
    {:noreply, state}
  end

  def handle_cast({:buttons, button_states}, state) do
    message = "Buttons: #{inspect button_states}"
    Ui.HardwareChannel.broadcast_update(message)
    {:noreply, state}
  end

  def handle_cast({:sensors, sensor_states}, state) do
    message = "Sensors: #{inspect sensor_states}"
    Ui.HardwareChannel.broadcast_update(message)
    {:noreply, state}
  end

  def init([]) do
    {:ok, %{}}
  end
end
