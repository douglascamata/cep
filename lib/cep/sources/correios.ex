defmodule Cep.Sources.Correios do
  use Cep.Sources.Base

  def get_address(cep) do
    wsdl_url = "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"
    cep = String.replace(cep, "-", "")

    case HTTPoison.post(wsdl_url, soap_template(cep)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> Codepagex.to_string!(:iso_8859_1) |> format_result}
      {:ok, %HTTPoison.Response{status_code: 500, body: body}} ->
        if cep_not_found?(body) do
          cep_not_found
        end
    end
  end

  defp soap_template(cep) do
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

  defp format_result(result) do
    import SweetXml
    result_fields = %{
      "bairro" => "neighborhood",
      "cep" => "cep",
      "cidade" => "city",
      "complemento" => "complement",
      "complemento2" => "complement2",
      "end" => "address",
      "uf" => "state"
    }

    for {tag, translated_tag} <- result_fields, into: %{} do
      {translated_tag, xpath(result, ~x"//return/#{tag}/text()") |> to_string}
    end
  end

  defp cep_not_found?(body) do
    import SweetXml
    message = xpath(body, ~x"//faultstring/text()") |> to_string
    message == "CEP NAO ENCONTRADO"
  end
end
