defmodule Logic.CounterCoordinator do
  use GenServer
  require Logger

  @hw_led Application.get_env(:ui, :led_hw)

  @r "red"
  @g "green"
  @y "yellow"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def send_update(new_update) do
    GenServer.cast(__MODULE__, {:new_update, new_update})
  end

  def init([]) do
    {:ok, %{}}
  end

  def handle_cast({:new_update, new_update}, state) do
    Logger.debug "Got from Twitter: #{new_update}"
    count = format_message(new_update)
    Logger.debug(inspect(count))
    light_leds(count)
    {:noreply, state}
  end

  defp format_message(input) do
    words =
      input
      |> String.split
    red = Enum.count(words, fn(x) -> x == @r end)
    yellow = Enum.count(words, fn(x) -> x == @y end)
    green = Enum.count(words, fn(x) -> x == @g end)
    {red, yellow, green}
  end

  defp light_leds({r, y, g}) do
    light_red_leds(r)
    light_yellow_leds(y)
    light_green_leds(g)
  end

  defp light_red_leds(0) do
    @hw_led.set_red(false)
  end

  defp light_red_leds(1) do
    @hw_led.set_red1(true)
    @hw_led.set_red2(false)
  end

  defp light_red_leds(x) when x >= 2 do
    @hw_led.set_red(true)
  end

  defp light_yellow_leds(0) do
    @hw_led.set_yellow(false)
  end

  defp light_yellow_leds(1) do
    @hw_led.set_yellow1(true)
    @hw_led.set_yellow2(false)
  end

  defp light_yellow_leds(x) when x >= 2 do
    @hw_led.set_yellow(true)
  end

  defp light_green_leds(0) do
    @hw_led.set_green(false)
  end

  defp light_green_leds(1) do
    @hw_led.set_green1(true)
    @hw_led.set_green2(false)
  end

  defp light_green_leds(x) when x >= 2 do
    @hw_led.set_green(true)
  end
end
