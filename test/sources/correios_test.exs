defmodule CepSourcesCorreiosTest do
  use ExUnit.Case

  @moduletag :live

  test "should get CEP code addresses" do
    {:ok, address} = Cep.Sources.Correios.get_address("29375-000")
    assert address.city == "Venda Nova do Imigrante"
  end

  test "should handle non-existent CEP" do
    {status, reason} = Cep.Sources.Correios.get_address("00000-000")
    assert status == :not_found
    assert reason == "CEP not found."
  end
end
