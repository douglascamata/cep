defmodule CepSourcesPostmonTest do
  use ExUnit.Case, async: true

  @moduletag :live

  describe "get_address/1" do
    test "should get CEP code addresses" do
      {:ok, address} = Cep.Sources.Postmon.get_address("29375-000")
      assert address.city == "Venda Nova do Imigrante"
    end

    test "should handle non-existent CEP code with Correios" do
      {status, reason} = Cep.Sources.Postmon.get_address("00000-000")
      assert status == :not_found
      assert reason == "CEP not found."
    end
  end
end
