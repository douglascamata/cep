defmodule Cep.Sources.Correios do
  import Cep.Sources.Base

  alias Cep.Sources.Correios.{Sanitizer, RequestBuilder, ResultFormatter, Errors}

  @behaviour Cep.Source
  @url "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"

  def get_address(cep) do
    case HTTPoison.post(@url, request_body(cep)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, ResultFormatter.format(body)}

      {:ok, %HTTPoison.Response{status_code: 500, headers: _headers, body: body}} ->
        cond do
          Errors.cep_not_found?(body) -> cep_not_found_error()
          Errors.invalid_cep?(body) -> cep_not_found_error()
          true -> unknown_error(body)
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp request_body(cep) do
    cep |> Sanitizer.sanitize() |> RequestBuilder.for_cep()
  end
end
