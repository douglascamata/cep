defmodule CepSourcesCorreiosRequestBuidlerTest do
  use ExUnit.Case, async: true
  alias Cep.Sources.Correios.RequestBuilder

  describe "for_cep/1" do
    test "should put the cep in the request body" do
      assert RequestBuilder.for_cep("mycep") == expected_body("mycep")
    end
  end

  defp expected_body(cep) do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
      <soapenv:Header />
      <soapenv:Body>
        <cli:consultaCEP>
          <cep>#{cep}</cep>
        </cli:consultaCEP>
      </soapenv:Body>
    </soapenv:Envelope>
    """
  end
end
