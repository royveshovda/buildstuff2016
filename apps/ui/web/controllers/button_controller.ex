defmodule Ui.ButtonController do
  use Ui.Web, :controller
  require Logger

  def index(conn, _params) do
    json(conn,[%{b1: "unknown"},%{b2: "unknown"}])
  end
end
