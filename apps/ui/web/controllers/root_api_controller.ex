defmodule Ui.RootApiController do
  use Ui.Web, :controller

  def index(conn, _params) do
    json(conn, %{link: [%{name: "leds", url: "/leds"}, %{name: "buttons", url: "/buttons"}, %{name: "sensors", url: "/sensors"}]})
  end
end
