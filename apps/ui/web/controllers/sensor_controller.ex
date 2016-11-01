defmodule Ui.SensorController do
  use Ui.Web, :controller
  require Logger

  def index(conn, _params) do
    json(conn,[%{temperature: "unknown"},%{humidity: "unknown"}])
  end

end
