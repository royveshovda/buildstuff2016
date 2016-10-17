defmodule Fw.Button do
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    {:ok, b1} = GpioRpi.start_link(5, :input)
    {:ok, b2} = GpioRpi.start_link(6, :input)
    :ok = GpioRpi.set_mode(b1, :down)
    :ok = GpioRpi.set_mode(b2, :down)
    :ok = GpioRpi.set_int(b1, :both)
    :ok = GpioRpi.set_int(b2, :both)
    {:ok, {}}
  end

  def handle_info({:gpio_interrupt, pin, :falling}, state) do
    ##TODO: Send event using GenStage
    IO.puts "Pin: #{pin} -- Falling"
    {:noreply, state}
  end

  def handle_info({:gpio_interrupt, pin, :rising}, state) do
    ##TODO: Send event using GenStage
    IO.puts "Pin: #{pin} -- Raising"
    {:noreply, state}
  end
end
