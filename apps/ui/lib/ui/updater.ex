defmodule Ui.Updater do
  use GenServer

  ## Client API
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

  ## Server API
  def init([]) do
    {:ok, %{}}
  end

  def handle_cast(data, state) do
    Ui.HardwareChannel.broadcast_update(data)
    {:noreply, state}
  end
end
