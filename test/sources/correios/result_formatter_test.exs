defmodule CepSourcesCorreiosResultFormatterTest do
  use ExUnit.Case, async: true
  alias Cep.Sources.Correios.ResultFormatter

  setup_all do
    {:ok, formatted_result: ResultFormatter.format(correios_response())}
  end

  describe "format/1" do
    test "should translate 'bairro' into 'neighborhood'", state do
      assert state[:formatted_result].neighborhood == correios_response_field("bairro")
    end

    test "should translate 'cep' into 'cep'", state do
      assert state[:formatted_result].cep == correios_response_field("cep")
    end

    test "should translate 'cidade' into 'city'", state do
      assert state[:formatted_result].city == correios_response_field("cidade")
    end

    test "should translate 'complemento' into 'complement'", state do
      assert state[:formatted_result].complement == correios_response_field("complemento")
    end

    test "should translate 'end' into 'street'", state do
      assert state[:formatted_result].street == correios_response_field("end")
    end

    test "should translate 'uf' into 'state'", state do
      assert state[:formatted_result].state == correios_response_field("uf")
    end
  end

  defp correios_response_field(name) do
    import SweetXml
    to_string(xpath(correios_response(), ~x"//return/#{name}/text()"))
  end

  defp correios_response do
    """
    <soap:Envelope
    xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">
    <soap:Body>
        <ns2:consultaCEPResponse
            xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">
            <return>
                <bairro></bairro>
                <cep>29375000</cep>
                <cidade>Venda Nova do Imigrante</cidade>
                <complemento></complemento>
                <complemento2></complemento2>
                <end></end>
                <id>0</id>
                <uf>ES</uf>
            </return>
        </ns2:consultaCEPResponse>
    </soap:Body>
    </soap:Envelope>
    """
  end
end
