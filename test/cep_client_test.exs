defmodule CepClientTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  doctest Cep

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    GenServer.start_link(Cep.Client, [])
    :ok
  end

  test "should get address of a CEP using Correios provider as default" do
    use_cassette "venda nova do imigrante - correios" do
      with_mock Cep.Sources.Correios, [:passthrough], [] do

        {:ok, address} = :poolboy.transaction(
          :cep_client,
          fn(server) -> GenServer.call(server, {:get_address, "29375-000", []}) end,
          :infinity
        )

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.Correios.get_address("29375-000")
      end
    end
  end

  test "should try next providers on failure of the default" do
    use_cassette "correios fail, viacep works" do
      with_mock Cep.Sources.Correios,
        [get_address: fn(_) -> {:not_found, "CEP not found."} end] do

        {:ok, address} = :poolboy.transaction(
          :cep_client,
          fn(server) -> GenServer.call(server, {:get_address, "29375-000", []}) end,
          :infinity
        )

        assert address["city"] == "Venda Nova do Imigrante"
      end
    end
  end

  test "should allow to choose the data provider" do
    use_cassette "venda nova do imigrante - viacep" do
      with_mock Cep.Sources.ViaCep, [:passthrough], [] do
        {:ok, address} = :poolboy.transaction(
          :cep_client,
          fn(server) ->
            GenServer.call(server, {:get_address, "29375-000", [source: :viacep]})
          end,
          :infinity
        )

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.ViaCep.get_address("29375-000")
      end
    end

    use_cassette "venda nova do imigrante - postmon" do
      with_mock Cep.Sources.Postmon, [:passthrough], [] do
        {:ok, address} = :poolboy.transaction(
          :cep_client,
          fn(server) ->
            GenServer.call(server, {:get_address, "29375-000", [source: :postmon]})
          end,
          :infinity
        )

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.Postmon.get_address("29375-000")
      end
    end

    use_cassette "venda nova do imigrante - correios" do
      with_mock Cep.Sources.Correios, [:passthrough], [] do
        {:ok, address} = :poolboy.transaction(
          :cep_client,
          fn(server) ->
            GenServer.call(server, {:get_address, "29375-000", [source: :correios]})
          end,
          :infinity
        )

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.Correios.get_address("29375-000")
      end
    end
  end

  test "should handle non-existent CEP with multiple sources" do
    use_cassette "non-existent CEP - multiple providers" do
      {status, _} = :poolboy.transaction(
        :cep_client,
        fn(server) -> GenServer.call(server, {:get_address, "00000-000", []}) end,
        :infinity
      )
      assert status == :not_found
    end
  end
end
