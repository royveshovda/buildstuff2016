defmodule Fw.Led do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
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
    {:ok, g1} = GpioRpi.start_link(22, :output)
    {:ok, g2} = GpioRpi.start_link(25, :output)
    {:ok, y1} = GpioRpi.start_link(27, :output)
    {:ok, y2} = GpioRpi.start_link(24, :output)
    {:ok, r1} = GpioRpi.start_link(17, :output)
    {:ok, r2} = GpioRpi.start_link(23, :output)

    state = %{
              g1: g1,
              g2: g2,
              y1: y1,
              y2: y2,
              r1: r1,
              r2: r2,
              g1_state: 0,
              g2_state: 0,
              y1_state: 0,
              y2_state: 0,
              r1_state: 0,
              r2_state: 0}
    {:ok, state}
  end

  def handle_cast({:switch, :green, switch_to}, state) do
    pid1 = state.g1
    pid2 = state.g2
    GpioRpi.write(pid1, switch_to)
    GpioRpi.write(pid2, switch_to)
    new_state = %{state | g1_state: switch_to, g2_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :g1, switch_to}, state) do
    pid = state.g1
    GpioRpi.write(pid, switch_to)
    new_state = %{state | g1_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :g2, switch_to}, state) do
    pid = state.g2
    GpioRpi.write(pid, switch_to)
    new_state = %{state | g2_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :yellow, switch_to}, state) do
    pid1 = state.y1
    pid2 = state.y2
    GpioRpi.write(pid1, switch_to)
    GpioRpi.write(pid2, switch_to)
    new_state = %{state | y1_state: switch_to, y2_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :y1, switch_to}, state) do
    pid = state.y1
    GpioRpi.write(pid, switch_to)
    new_state = %{state | y1_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :y2, switch_to}, state) do
    pid = state.y2
    GpioRpi.write(pid, switch_to)
    new_state = %{state | y2_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :red, switch_to}, state) do
    pid1 = state.r1
    pid2 = state.r2
    GpioRpi.write(pid1, switch_to)
    GpioRpi.write(pid2, switch_to)
    new_state = %{state | r1_state: switch_to, r2_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :r1, switch_to}, state) do
    pid = state.r1
    GpioRpi.write(pid, switch_to)
    new_state = %{state | r1_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  def handle_cast({:switch, :r2, switch_to}, state) do
    pid = state.r2
    GpioRpi.write(pid, switch_to)
    new_state = %{state | r2_state: switch_to}
    message = get_message_from_state(new_state)
    Ui.Updater.send_leds_update(message)
    {:noreply, new_state}
  end

  defp get_message_from_state(state) do
    %{g1: state.g1_state, g2: state.g2_state,
      y1: state.y1_state, y2: state.y2_state,
      r1: state.r1_state, r2: state.r2_state}
  end
end
