defmodule Cep.Sources.Test.Unavailable do
  def get_address(_cep) do
    {:error, "Unavailable."}
  end
end
