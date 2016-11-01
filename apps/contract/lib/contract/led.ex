defmodule Contract.Led do
  @callback get_state() :: %Contract.LedState{}
  @callback set_green(boolean()) :: none()
  @callback set_green1(boolean()) :: none()
  @callback set_green2(boolean()) :: none()
  @callback set_yellow(boolean()) :: none()
  @callback set_yellow1(boolean()) :: none()
  @callback set_yellow2(boolean()) :: none()
  @callback set_red(boolean()) :: none()
  @callback set_red1(boolean()) :: none()
  @callback set_red2(boolean()) :: none()
end
