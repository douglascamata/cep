defmodule CepSourcesCorreiosTest do
  use ExUnit.Case, async: true

  @moduletag :live

  describe "get_address/1" do
    test "should get CEP code addresses" do
      {:ok, address} = Cep.Sources.Correios.get_address("29375-000")
      assert address.city == "Venda Nova do Imigrante"
    end

    test "should handle non-existent CEP" do
      {status, reason} = Cep.Sources.Correios.get_address("99999-999")
      assert status == :not_found
      assert reason == "CEP not found."
    end

    test "should handle invalid CEP as not found" do
      {status, reason} = Cep.Sources.Correios.get_address("00000-000")
      assert status == :not_found
      assert reason == "CEP not found."
    end
  end
end
