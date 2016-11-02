defmodule Ui.Simulator.Button do
  use GenServer
  @behaviour Contract.Button

  ## Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def set_random_values() do
    get_hardware_state()
  end

  def get_hardware_state() do
    GenServer.call(__MODULE__, :get_hardware_state)
  end

  ## Server API
  def init([]) do
    {:ok, %Contract.ButtonState{b1: :up, b2: :up}}
  end

  def handle_call(:get_hardware_state, _from, _state) do
    new_state = %Contract.ButtonState{b1: random_up_down, b2: random_up_down}
    message = get_message_from_state(new_state)
    Ui.Updater.send_buttons_update(message)
    {:reply, new_state, new_state}
  end

  defp get_message_from_state(state) do
    %{temperature_button: state.b1, humidity_button: state.b2}
  end

  defp random_up_down() do
    to_up_down(Enum.random([0,1]))
  end

  defp to_up_down(0), do: :up
  defp to_up_down(1), do: :down
end
