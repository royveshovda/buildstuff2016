defmodule Ui.ButtonController do
  use Ui.Web, :controller
  require Logger

  @hw_button Application.get_env(:ui, :button_hw)

  def index(conn, _params) do
    state = @hw_button.get_hardware_state()
    json(conn, state)
  end
end
