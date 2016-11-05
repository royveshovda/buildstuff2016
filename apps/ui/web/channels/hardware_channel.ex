defmodule Ui.HardwareChannel do
  use Ui.Web, :channel
  #use Phoenix.Channel



  def broadcast_update({:leds, led_states}) do
    Ui.Endpoint.broadcast("hardware:all", "new_update", %{body: led_states, type: "1"})
  end

  def broadcast_update({:buttons, button_states}) do
    Ui.Endpoint.broadcast("hardware:all", "new_update", %{body: button_states, type: "2"})
  end

  def broadcast_update({:sensors, sensor_states}) do
    Ui.Endpoint.broadcast("hardware:all", "new_update", %{body: sensor_states, type: "3"})
  end

  def join("hardware:all", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_update", %{"body" => body}, socket) do
    broadcast! socket, "new_update", %{body: body}
    {:noreply, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
