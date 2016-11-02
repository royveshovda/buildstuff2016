defmodule Contract.Button do
  @callback get_hardware_state() :: %Contract.ButtonState{}
end
