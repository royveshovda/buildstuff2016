defmodule Fw.Button do
  use GenServer

  @pin_temperature 5
  @pin_humidity 6

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    {:ok, b1} = GpioRpi.start_link(@pin_temperature, :input)
    {:ok, b2} = GpioRpi.start_link(@pin_humidity, :input)
    :ok = GpioRpi.set_mode(b1, :down)
    :ok = GpioRpi.set_mode(b2, :down)
    :ok = GpioRpi.set_int(b1, :both)
    :ok = GpioRpi.set_int(b2, :both)
    {:ok, {}}
  end

  def handle_info({:gpio_interrupt, _pin, :falling}, state) do
    # Do nothing for now
    #IO.puts "Pin: #{pin} -- Falling"
    {:noreply, state}
  end

  def handle_info({:gpio_interrupt, pin, :rising}, state) do
    send_info(pin)
    #IO.puts "Pin: #{pin} -- Raising"
    {:noreply, state}
  end

  defp send_info(@pin_temperature) do
    temp = Fw.Sensor.get_temperature()
    # Include node-name and timestamp
    message = "I got temperature: #{temp}"
    Logic.TwitterWorker.send(message)
  end

  defp send_info(@pin_humidity) do
    hum = Fw.Sensor.get_humidity()
    # Include node-name and timestamp
    message = "I got humidity: #{hum}"
    Logic.TwitterWorker.send(message)
  end
end
