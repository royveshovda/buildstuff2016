defmodule Logic.CounterCoordinator do
  use GenServer

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
    count = format_message(new_update)
    IO.inspect(count)
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
    Fw.Led.set_red(0)
    #IO.puts("Red: 0")
  end

  defp light_red_leds(1) do
    Fw.Led.set_red1(1)
    Fw.Led.set_red2(0)
    #IO.puts("Red: 1")
  end

  defp light_red_leds(x) when x >= 2 do
    Fw.Led.set_red(1)
    #IO.puts("Red: 2")
  end

  defp light_yellow_leds(0) do
    Fw.Led.set_yellow(0)
    #IO.puts("Yellow: 0")
  end

  defp light_yellow_leds(1) do
    Fw.Led.set_yellow1(1)
    Fw.Led.set_yellow2(0)
    #IO.puts("Yellow: 1")
  end

  defp light_yellow_leds(x) when x >= 2 do
    Fw.Led.set_yellow(1)
    #IO.puts("Yellow: 2")
  end

  defp light_green_leds(0) do
    Fw.Led.set_green(0)
    #IO.puts("Green: 0")
  end

  defp light_green_leds(1) do
    Fw.Led.set_green1(1)
    Fw.Led.set_green2(0)
    #IO.puts("Green: 1")
  end

  defp light_green_leds(x) when x >= 2 do
    Fw.Led.set_green(1)
    #IO.puts("Green: 2")
  end
end
