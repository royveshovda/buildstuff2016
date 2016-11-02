defmodule Fw.Sensor do
  use GenServer
  @behaviour Contract.Sensor

  ## Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_temperature() do
    GenServer.call(__MODULE__, :get_temperature)
  end

  def get_humidity() do
    GenServer.call(__MODULE__, :get_humidity)
  end

  ## Server API
  def init([]) do
    {:ok, pid} = I2c.start_link("i2c-1", 0x40)
    state = %{pid: pid, temperature: :unknown, humidity: :unknown}
    {:ok, state}
  end

  def handle_call(:get_temperature, _from, state) do
    pid = state.pid
    I2c.write(pid, <<0xF3>>)
    Process.sleep(25)
    <<high, low, _chk>> = I2c.read(pid, 3)
    temp = ((high*256 + low) * 175.72 / 65536) - 46.85

    new_state = %{state | temperature: temp}
    message = get_message_from_state(new_state)
    Ui.Updater.send_sensor_update(message)

    {:reply, temp, new_state}
  end

  def handle_call(:get_humidity, _from, state) do
    pid = state.pid
    I2c.write(pid, <<0xF5>>)
    Process.sleep(25)
    <<high, low, _chk>> = I2c.read(pid, 3)
    hum = ((high*256 + low) * 125 / 65536) - 6

    new_state = %{state | humidity: hum}
    message = get_message_from_state(new_state)
    Ui.Updater.send_sensor_update(message)

    {:reply, hum, new_state}
  end

  defp get_message_from_state(state) do
    %{temperature: state.temperature, humidity: state.humidity}
  end
end
