defmodule CepSourcesCorreiosErrorsTest do
  use ExUnit.Case, async: true
  alias Cep.Sources.Correios.Errors

  describe "cep_not_found?/1" do
    test "should return true if the cep was not found" do
      assert Errors.cep_not_found?(request_body())
    end
  end

  defp request_body do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
      <soapenv:Header />
      <soapenv:Body>
        <cli:consultaCEP>
          <faultstring>CEP NAO ENCONTRADO</faultstring>
        </cli:consultaCEP>
      </soapenv:Body>
    </soapenv:Envelope>
    """
  end
end