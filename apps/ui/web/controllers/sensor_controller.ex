defmodule Ui.SensorController do
  use Ui.Web, :controller
  require Logger

  @hw Application.get_env(:ui, :sensor_hw)

  def index(conn, _params) do
    temperature = @hw.get_temperature()
    humidity = @hw.get_humidity()
    json(conn, %{temperature: temperature, humidity: humidity})
  end
end
