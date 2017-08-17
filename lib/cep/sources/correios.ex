defmodule Cep.Sources.Correios do
  use Cep.Sources.Base

  @behaviour Cep.Source

  def get_address(cep) do
    wsdl_url = "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"
    cep = String.replace(cep, "-", "")

    case HTTPoison.post(wsdl_url, soap_template(cep)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> format_result}
      {:ok, %HTTPoison.Response{status_code: 500, body: body}} ->
        if cep_not_found?(body) do
          cep_not_found
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
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
      "end" => "street",
      "uf" => "state"
    }

    result_map = for {tag, translated_tag} <- result_fields, into: %{} do
      element = xpath(result, ~x"//return/#{tag}/text()")
      {translated_tag,  to_string(element)}
    end
    Cep.Address.new(result_map)
  end

  defp cep_not_found?(body) do
    import SweetXml
    message = xpath(body, ~x"//faultstring/text()")
    to_string(message) == "CEP NAO ENCONTRADO"
  end
end
