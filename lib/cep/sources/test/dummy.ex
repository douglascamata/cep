defmodule Cep.Sources.Test.Dummy do
  def get_address("29375-000") do
    {:ok, %Cep.Address{city: "Venda Nova do Imigrante"}}
  end

  def get_address("00000-000") do
    {:not_found, "Cep not found."}
  end
end
