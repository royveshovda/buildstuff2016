defmodule Ui.Simulator.Sensor do
  use GenServer
  @behaviour Contract.Sensor

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def set_random_values() do
    get_temperature()
    get_humidity()
  end

  def get_temperature() do
    GenServer.call(__MODULE__, :get_temperature)
  end

  def get_humidity() do
    GenServer.call(__MODULE__, :get_humidity)
  end

  def init([]) do
    state = %{temperature: :unknown, humidity: :unknown}
    {:ok, state}
  end

  def handle_call(:get_temperature, _from, state) do
    temp = :rand.uniform * 10 + 20
    new_state = %{state | temperature: temp}
    message = get_message_from_state(new_state)
    Ui.Updater.send_sensor_update(message)
    {:reply, temp, new_state}
  end

  def handle_call(:get_humidity, _from, state) do
    hum = :rand.uniform * 10 + 40
    new_state = %{state | humidity: hum}
    message = get_message_from_state(new_state)
    Ui.Updater.send_sensor_update(message)
    {:reply, hum, new_state}
  end

  defp get_message_from_state(state) do
    %{temperature: state.temperature, humidity: state.humidity}
  end
end
