defmodule CepSourcesPostmonTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Cep

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "should handle non-existent CEP code with Correios" do
    use_cassette "non-existent CEP - Postmon" do
      {status, reason} = Cep.Sources.Postmon.get_address("00000-000")
      assert status == :not_found
      assert reason == "CEP not found."
    end
  end
end
