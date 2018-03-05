defmodule Cep.Sources.Correios.RequestBuilder do
  def for_cep(cep) do
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
