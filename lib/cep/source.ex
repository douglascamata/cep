defmodule Cep.Source do
  @callback get_address(cep :: String.t()) ::
              {:ok, %Cep.Address{}} | {:not_found, String.t()} | {:error, String.t()}
end
