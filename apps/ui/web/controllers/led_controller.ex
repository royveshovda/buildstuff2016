defmodule Ui.LedController do
  use Ui.Web, :controller
  require Logger

  @hw_led Application.get_env(:ui, :led_hw)

  def index(conn, _params) do
    state = @hw_led.get_hardware_state()
    json(conn, state)
  end

  def update(conn, %{"id" => id, "state" => state}) do
    convert_state(state)
    |> switch_led(id)
    |> return_status(conn)
  end

  defp return_status(:accepted, conn) do
    put_status(conn, :accepted)
    |> json(%{result: "Accepted"})
  end

  defp return_status(result_code, conn) do
    put_status(conn, result_code)
    |> json(%{result: "Not acceptable"})
  end

  defp convert_state(state) do
    case state do
      "1" -> true
      "0" -> false
      _ ->
        message = "Unknown state received: #{inspect state}"
        Logger.warn(message)
        -1
    end
  end

  defp switch_led(-1, _led) do
    :not_acceptable
  end

  defp switch_led(state, led) do
    case led do
      "g1" ->
        @hw_led.set_green1(state)
        :accepted
      "g2" ->
        @hw_led.set_green2(state)
        :accepted
      "y1" ->
        @hw_led.set_yellow1(state)
        :accepted
      "y2" ->
        @hw_led.set_yellow2(state)
        :accepted
      "r1" ->
        @hw_led.set_red1(state)
        :accepted
      "r2" ->
        @hw_led.set_red2(state)
        :accepted
      _ ->
        Logger.warn("Unknown led received: #{inspect led}")
        :not_acceptable
    end
  end
end
