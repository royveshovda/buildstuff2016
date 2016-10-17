defmodule Fw.Led do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def set_green(state) do
    GenServer.cast(__MODULE__, {:switch, :green, state})
  end

  def set_green1(state) do
    GenServer.cast(__MODULE__, {:switch, :g1, state})
  end

  def set_green2(state) do
    GenServer.cast(__MODULE__, {:switch, :g2, state})
  end

  def set_yellow(state) do
    GenServer.cast(__MODULE__, {:switch, :yellow, state})
  end

  def set_yellow1(state) do
    GenServer.cast(__MODULE__, {:switch, :y1, state})
  end

  def set_yellow2(state) do
    GenServer.cast(__MODULE__, {:switch, :y2, state})
  end

  def set_red(state) do
    GenServer.cast(__MODULE__, {:switch, :red, state})
  end

  def set_red1(state) do
    GenServer.cast(__MODULE__, {:switch, :r1, state})
  end

  def set_red2(state) do
    GenServer.cast(__MODULE__, {:switch, :r2, state})
  end

  def init([]) do
    {:ok, g1} = GpioRpi.start_link(22, :output)
    {:ok, g2} = GpioRpi.start_link(25, :output)
    {:ok, y1} = GpioRpi.start_link(27, :output)
    {:ok, y2} = GpioRpi.start_link(24, :output)
    {:ok, r1} = GpioRpi.start_link(17, :output)
    {:ok, r2} = GpioRpi.start_link(23, :output)

    state = %{g1: g1, g2: g2, y1: y1, y2: y2, r1: r1, r2: r2}
    {:ok, state}
  end

  def handle_cast({:switch, :green, switch_to}, state) do
    pid1 = state.g1
    pid2 = state.g2
    GpioRpi.write(pid1, switch_to)
    GpioRpi.write(pid2, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :g1, switch_to}, state) do
    pid = state.g1
    GpioRpi.write(pid, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :g2, switch_to}, state) do
    pid = state.g2
    GpioRpi.write(pid, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :yellow, switch_to}, state) do
    pid1 = state.y1
    pid2 = state.y2
    GpioRpi.write(pid1, switch_to)
    GpioRpi.write(pid2, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :y1, switch_to}, state) do
    pid = state.y1
    GpioRpi.write(pid, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :y2, switch_to}, state) do
    pid = state.y2
    GpioRpi.write(pid, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :red, switch_to}, state) do
    pid1 = state.r1
    pid2 = state.r2
    GpioRpi.write(pid1, switch_to)
    GpioRpi.write(pid2, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :r1, switch_to}, state) do
    pid = state.r1
    GpioRpi.write(pid, switch_to)
    {:noreply, state}
  end

  def handle_cast({:switch, :r2, switch_to}, state) do
    pid = state.r2
    GpioRpi.write(pid, switch_to)
    {:noreply, state}
  end
end
