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
    IO.puts "Web event LEDs:"
    IO.inspect led_states
    {:noreply, state}
  end

  def handle_cast({:buttons, button_states}, state) do
    IO.puts "Web event buttons:"
    IO.inspect button_states
    {:noreply, state}
  end

  def handle_cast({:sensors, sensor_states}, state) do
    IO.puts "Web event sensors:"
    IO.inspect sensor_states
    {:noreply, state}
  end

  def init([]) do
    {:ok, %{}}
  end
end
