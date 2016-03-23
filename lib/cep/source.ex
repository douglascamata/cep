defmodule Cep.Source do
  @callback get_address(cep :: String.t) :: %Cep.Address{}
end
