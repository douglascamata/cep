defmodule Cep.Source do
  alias Cep.Address

  @callback get_address(cep :: String.t()) ::
              {:ok, %Cep.Address{}} | {:not_found, String.t()} | {:error, String.t()}
end
