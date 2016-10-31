defmodule Ui.LedController do
  use Ui.Web, :controller
  require Logger
  def index(conn, _params) do
    json(conn,[%{id: "g1"},%{id: "g2"},%{id: "y1"},%{id: "y2"},%{id: "r1"},%{id: "r2"}])
  end

  def show(conn, %{"id" => id}) do
    json(conn, %{id: id, state: "Unknown"})
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
      "1" -> 1
      "0" -> 0
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
        #Fw.Led.set_green1(state)
        IO.puts "Green1: #{state}"
        :accepted
      "g2" ->
        #Fw.Led.set_green2(state)
        IO.puts "Green2: #{state}"
        :accepted
      "y1" ->
        #Fw.Led.set_yellow1(state)
        IO.puts "Yellow1: #{state}"
        :accepted
      "y2" ->
        #Fw.Led.set_yellow2(state)
        IO.puts "Yellow2: #{state}"
        :accepted
      "r1" ->
        #Fw.Led.set_red1(state)
        IO.puts "Red1: #{state}"
        :accepted
      "r2" ->
        #Fw.Led.set_red2(state)
        IO.puts "Red2: #{state}"
        :accepted
      _ ->
        Logger.warn("Unknown led received: #{inspect led}")
        :not_acceptable
    end
  end
end
