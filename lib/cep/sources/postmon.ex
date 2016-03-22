defmodule Cep.Sources.Postmon do
  use Cep.Sources.Base

  def get_address(cep) do
    case HTTPoison.get("http://api.postmon.com.br/v1/cep/#{cep}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded_body} = Poison.decode(body)
        {:ok, format_result_json(decoded_body)}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        cep_not_found
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
