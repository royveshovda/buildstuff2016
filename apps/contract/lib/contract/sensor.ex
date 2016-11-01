defmodule Contract.Sensor do
  @callback get_temperature() :: float()
  @callback get_humidity() :: float()
end
