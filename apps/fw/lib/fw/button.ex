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
    {:ok, %{b1: :up, b2: :up}}
  end

  def handle_info({:gpio_interrupt, @pin_temperature, :falling}, state) do
    new_state = %{state | b1: :up}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    {:noreply, new_state}
  end

  def handle_info({:gpio_interrupt, @pin_humidity, :falling}, state) do
    new_state = %{state | b2: :up}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    {:noreply, new_state}
  end

  def handle_info({:gpio_interrupt, @pin_temperature, :rising}, state) do
    new_state = %{state | b1: :down}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    send_temperature
    {:noreply, new_state}
  end

  def handle_info({:gpio_interrupt, @pin_humidity, :rising}, state) do
    new_state = %{state | b2: :down}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    send_humidity
    {:noreply, new_state}
  end

  defp get_message_from_state(state) do
    %{temperature_button: state.b1, humidity_button: state.b2}
  end

  defp send_temperature() do
    temp = Fw.Sensor.get_temperature()
    # Include node-name and timestamp
    message = "I got temperature: #{temp}"
    Logic.TwitterWorker.send(message)
  end

  defp send_humidity() do
    hum = Fw.Sensor.get_humidity()
    # Include node-name and timestamp
    message = "I got humidity: #{hum}"
    Logic.TwitterWorker.send(message)
  end
end
