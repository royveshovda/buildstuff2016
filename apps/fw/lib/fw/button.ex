defmodule Fw.Button do
  use GenServer
  @behaviour Contract.Button

  @pin_temperature 5
  @pin_humidity 6

  ## Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_hardware_state() do
     GenServer.call(__MODULE__, :get_hardware_state)
  end

  ## Server API
  def init([]) do
    {:ok, b1} = GpioRpi.start_link(@pin_temperature, :input)
    {:ok, b2} = GpioRpi.start_link(@pin_humidity, :input)
    :ok = GpioRpi.set_mode(b1, :down)
    :ok = GpioRpi.set_mode(b2, :down)
    :ok = GpioRpi.set_int(b1, :both)
    :ok = GpioRpi.set_int(b2, :both)
    {:ok, %Contract.ButtonState{b1: :up, b2: :up}}
  end

  def handle_call(:get_hardware_state, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:gpio_interrupt, @pin_temperature, :falling}, state) do
    new_state = %Contract.ButtonState{state | b1: :up, button_updated: :b1}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    {:noreply, new_state}
  end

  def handle_info({:gpio_interrupt, @pin_humidity, :falling}, state) do
    new_state = %Contract.ButtonState{state | b2: :up, button_updated: :b2}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    {:noreply, new_state}
  end

  def handle_info({:gpio_interrupt, @pin_temperature, :rising}, state) do
    new_state = %Contract.ButtonState{state | b1: :down, button_updated: :b1}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    send_temperature
    {:noreply, new_state}
  end

  def handle_info({:gpio_interrupt, @pin_humidity, :rising}, state) do
    new_state = %Contract.ButtonState{state | b2: :down, button_updated: :b2}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    send_humidity
    {:noreply, new_state}
  end

  defp get_message_from_state(state) do
    %{temperature_button: state.b1, humidity_button: state.b2, button_updated: state.button_updated}
  end

  defp send_temperature() do
    temp = Fw.Sensor.get_temperature()
    stamp = "#{DateTime.utc_now |> DateTime.to_time |> Time.to_string}Z"
    node = "#{Node.self()}"

    message = "I got temperature: #{temp} (timestamp: #{stamp}) (node: #{node})"

    Logic.TwitterWorker.send(message)
  end

  defp send_humidity() do
    hum = Fw.Sensor.get_humidity()
    stamp = "#{DateTime.utc_now |> DateTime.to_time |> Time.to_string}Z"
    node = "#{Node.self()}"

    message = "I got humidity: #{hum} (timestamp: #{stamp}) (node: #{node})"

    Logic.TwitterWorker.send(message)
  end
end
