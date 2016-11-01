defmodule Ui.Simulator.Led do
  use GenServer
  @behaviour Contract.Led

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def set_green(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :green, switch_to})
  end

  def set_green1(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :g1, switch_to})
  end

  def set_green2(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :g2, switch_to})
  end

  def set_yellow(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :yellow, switch_to})
  end

  def set_yellow1(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :y1, switch_to})
  end

  def set_yellow2(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :y2, switch_to})
  end

  def set_red(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :red, switch_to})
  end

  def set_red1(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :r1, switch_to})
  end

  def set_red2(switch_to) do
    GenServer.cast(__MODULE__, {:switch, :r2, switch_to})
  end

  def init([]) do
    state = %Contract.LedState{g1: 0, g2: 0, y1: 0, y2: 0, r1: 0, r2: 0}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:switch, :green, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Green1: #{int_switch_to}"
    IO.puts "Green2: #{int_switch_to}"
    new_state = %{state | g1: int_switch_to, g2: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :g1, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Green1: #{int_switch_to}"
    new_state = %{state | g1: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :g2, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Green2: #{int_switch_to}"
    new_state = %{state | g2: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :yellow, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Yellow1: #{int_switch_to}"
    IO.puts "Yellow2: #{int_switch_to}"
    new_state = %{state | y1: int_switch_to, y2: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :y1, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Yellow1: #{int_switch_to}"
    new_state = %{state | y1: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :y2, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Yellow2: #{int_switch_to}"
    new_state = %{state | y2: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :red, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Red1: #{int_switch_to}"
    IO.puts "Red2: #{int_switch_to}"
    new_state = %{state | r1: int_switch_to, r2: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :r1, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Red1: #{int_switch_to}"
    new_state = %{state | r1: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :r2, switch_to}, state) do
    int_switch_to = convert_switch_to(switch_to)
    IO.puts "Red2: #{int_switch_to}"
    new_state = %{state | r2: int_switch_to}
    Ui.Updater.send_leds_update(new_state)
    {:noreply, new_state}
  end

  defp convert_switch_to(true), do: 1
  defp convert_switch_to(false), do: 0

end
