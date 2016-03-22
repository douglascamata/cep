defmodule CepTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "should get address of a CEP" do
    use_cassette "venda nova do imigrante - correios" do
      {:ok, address} = Cep.get_address("29375-000")

      assert address["city"] == "Venda Nova do Imigrante"
    end
  end

  test "should be able to inform the list of available sources" do
    sources = Cep.sources
    assert sources == [:correios, :viacep, :postmon]
  end

  test "should forward get_address calls to Cep.Client" do
    use_cassette "venda nova do imigrante - correios" do
      with_mock GenServer, [:passthrough], [] do
        Cep.get_address("29375-000")

        assert called GenServer.call(:_, {:get_address, "29375-000", []})
      end
    end
  end
end
