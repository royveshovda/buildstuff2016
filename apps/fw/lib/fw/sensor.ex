defmodule Fw.Sensor do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_temperature() do
    GenServer.call(__MODULE__, :get_temperature)
  end

  def get_humidity() do
    GenServer.call(__MODULE__, :get_humidity)
  end


  def init(:ok) do
    {:ok, pid} = I2c.start_link("i2c-1", 0x40)
    state = %{pid: pid}
    {:ok, state}
  end

  def handle_call(:get_temperature, _from, state) do
    pid = state.pid
    I2c.write(pid, <<0xF3>>)
    Process.sleep(25)
    <<high, low, _chk>> = I2c.read(pid, 3)
    temp = ((high*256 + low) * 175.72 / 65536) - 46.85
    {:reply, temp, state}
  end

  def handle_call(:get_humidity, _from, state) do
    pid = state.pid
    I2c.write(pid, <<0xF5>>)
    Process.sleep(25)
    <<high, low, _chk>> = I2c.read(pid, 3)
    hum = ((high*256 + low) * 125 / 65536) - 6
    {:reply, hum, state}
  end
end
