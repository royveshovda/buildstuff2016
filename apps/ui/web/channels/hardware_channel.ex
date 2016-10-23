defmodule Ui.HardwareChannel do
  use Ui.Web, :channel
  #use Phoenix.Channel

  def broadcast_update(sensor_data) do
    Ui.Endpoint.broadcast("hardware:all", "new_update", %{body: sensor_data})
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
