defmodule CepClientTest do
  use ExUnit.Case

  test "should get address of a CEP using the first provider" do
    {:ok, address} = Cep.Client.get_address "29375-000"
    assert address.city == "Venda Nova do Imigrante"
  end

  test "should try next providers on failure of the default" do
    {:ok, address} = Cep.Client.get_address "29375-000", sources: [:unavailable, :dummy]
    assert address.city == "Venda Nova do Imigrante"
  end

  test "should allow to choose the data provider" do
    {:ok, address} = Cep.Client.get_address "29375-000", source: :alternative
    assert address.city == "Alternative"

    {:ok, address} = Cep.Client.get_address "29375-000", source: :dummy
    assert address.city == "Venda Nova do Imigrante"
  end

  test "should handle non-existent CEP with multiple sources" do
    {status, _} = Cep.Client.get_address "00000-000", sources: [:alternative, :dummy]
    assert status == :not_found
  end

  test "should inform error if no source responds with address or not found" do
    {error, reason} = Cep.Client.get_address "00000-000", sources: [:unavailable, :unavailable]
    assert error == :error
    assert reason == "Unavailable."
  end

  test "should inform the used sources when there is configuration" do
    assert Cep.Client.used_sources == [:dummy]
  end

  test "should be able to inform all the sources" do
    sources = Cep.Client.all_sources
    assert sources == [:unavailable, :alternative, :dummy, :correios, :viacep, :postmon]
  end
end
