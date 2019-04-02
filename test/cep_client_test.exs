defmodule CepSourceTest do
  def get_address("00000-001") do
    {:ok, %Cep.Address{city: "Piraque"}}
  end
end

defmodule CepClientTest do
  use ExUnit.Case, async: true

  describe "get_address/1" do
    test "should get address of a CEP using the first provider" do
      {:ok, address} = Cep.Client.get_address("29375-000")
      assert address.city == "Venda Nova do Imigrante"
    end
  end

  describe "get_address/2" do
    test "should try next providers on failure of the default" do
      {:ok, address} = Cep.Client.get_address("29375-000", sources: [:unavailable, :dummy])
      assert address.city == "Venda Nova do Imigrante"
    end

    test "should allow to choose the data provider" do
      {:ok, address} = Cep.Client.get_address("29375-000", source: :alternative)
      assert address.city == "Alternative"

      {:ok, address} = Cep.Client.get_address("29375-000", source: :dummy)
      assert address.city == "Venda Nova do Imigrante"
    end

    test "should handle non-existent CEP with multiple sources" do
      {status, _} = Cep.Client.get_address("00000-000", sources: [:alternative, :dummy])
      assert status == :not_found
    end

    test "should inform error if no source responds with address or not found" do
      {error, reason} = Cep.Client.get_address("00000-000", sources: [:unavailable, :unavailable])
      assert error == :error
      assert reason == "Unavailable."
    end

    test "should accept a module as sources keyword" do
      {:ok, address} = Cep.Client.get_address("00000-001", sources: [:dummy, CepSourceTest])

      assert address.city == "Piraque"
    end

    test "should accept a module as source keyword" do
      {:ok, address} = Cep.Client.get_address("00000-001", source: CepSourceTest)

      assert address.city == "Piraque"
    end
  end

  describe "used_sources/0" do
    test "should inform the used sources when there is configuration" do
      assert Cep.Client.used_sources() == [:dummy]
    end
  end

  describe "all_sources/0" do
    test "should be able to inform all the sources" do
      sources = Cep.Client.all_sources()
      assert sources == [:unavailable, :alternative, :dummy, :correios, :viacep, :postmon]
    end
  end
end
