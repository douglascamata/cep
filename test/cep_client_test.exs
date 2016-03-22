defmodule CepClientTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "should get address of a CEP using Correios provider as default" do
    use_cassette "venda nova do imigrante - correios" do
      with_mock Cep.Sources.Correios, [:passthrough], [] do

        {:ok, address} = Cep.Client.get_address "29375-000"

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.Correios.get_address("29375-000")
      end
    end
  end

  test "should try next providers on failure of the default" do
    use_cassette "correios fail, viacep works" do
      with_mock Cep.Sources.Correios,
        [get_address: fn(_) -> {:not_found, "CEP not found."} end] do

        {:ok, address} = Cep.Client.get_address "29375-000"

        assert address["city"] == "Venda Nova do Imigrante"
      end
    end
  end

  test "should allow to choose the data provider" do
    use_cassette "venda nova do imigrante - viacep" do
      with_mock Cep.Sources.ViaCep, [:passthrough], [] do
        {:ok, address} = Cep.Client.get_address "29375-000", source: :viacep

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.ViaCep.get_address("29375-000")
      end
    end

    use_cassette "venda nova do imigrante - postmon" do
      with_mock Cep.Sources.Postmon, [:passthrough], [] do
        {:ok, address} = Cep.Client.get_address "29375-000", source: :postmon

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.Postmon.get_address("29375-000")
      end
    end

    use_cassette "venda nova do imigrante - correios" do
      with_mock Cep.Sources.Correios, [:passthrough], [] do
        {:ok, address} = Cep.Client.get_address "29375-000", source: :correios

        assert address["city"] == "Venda Nova do Imigrante"
        assert called Cep.Sources.Correios.get_address("29375-000")
      end
    end
  end

  test "should handle non-existent CEP with multiple sources" do
    use_cassette "non-existent CEP - multiple providers" do
      {status, _} = Cep.Client.get_address "00000-000"

      assert status == :not_found
    end
  end

  test "should inform the used sources when there is configuration" do
    with_mock Application, [get_env: fn(:cep, :sources, _) ->
      [:viacep] end] do
      assert Cep.Client.used_sources == [:viacep]

      assert called Application.get_env(:cep, :sources, Cep.Client.all_sources)
    end
  end

  test "should inform the used sources when there is no configuration" do
    previous_all_sources = Cep.Client.all_sources
    with_mock Application, [get_env: fn(_, _, all) ->
      all end] do
      assert Cep.Client.all_sources == previous_all_sources
    end
  end

  test "should consider config sources when there is no source(s) keyword arg" do
    use_cassette "venda nova do imigrante - correios" do
      with_mock Cep.Client, [:passthrough], [] do
        with_mock Application, [get_env: fn(_app, _key, _default) ->
          [:correios] end] do
          Cep.Client.get_address "29375-000"
          assert called Application.get_env(:cep, :sources, :_)
        end
        assert not called Cep.Client.all_sources
      end
    end
  end

  test "source keyword argument should override config sources" do
    use_cassette "venda nova do imigrante - correios" do
      with_mock Cep.Client, [:passthrough], [] do
        with_mock Application, [get_env: fn(_app, _key, _default) ->
          [:viacep] end] do
          Cep.Client.get_address "29375-000", source: :correios
          assert not called Application.get_env(:cep, :sources, :_)
        end
        assert not called Cep.Client.all_sources
      end
    end
  end

  test "sources keyword argument should override config sources" do
    use_cassette "venda nova do imigrante - correios" do
      with_mock Keyword, [:passthrough], [] do
        Cep.Client.get_address "29375-000", sources: [:correios, :viacep]
        assert called Keyword.get([sources: [:correios, :viacep]], :sources, :_)
      end
    end
  end
end
