defmodule Ui.LedController do
  use Ui.Web, :controller
  require Logger

  @hw_led Application.get_env(:ui, :led_hw)

  def index(conn, _params) do
    state = @hw_led.get_hardware_state()
    json(conn, state)
  end

  def show(conn, %{"id" => id}) do
    state = @hw_led.get_hardware_state()
    id_key = id_string_to_atom(id)
    case Map.get(state, id_key) do
      nil ->
        put_status(conn, :not_found)
        |> json(%{error: "not found"})
      result ->
        json(conn, %{value: result})
    end
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

  defp id_string_to_atom (id) do
    case id do
      "g1" -> :g1
      "g2" -> :g2
      "y1" -> :y1
      "y2" -> :y2
      "r1" -> :r1
      "r2" -> :r2
      _ -> :unknown
    end
  end
end
