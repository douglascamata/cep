defmodule Cep.Sources.ViaCep do
  use Cep.Sources.Base

  def get_address(cep) do
    case HTTPoison.get("http://viacep.com.br/ws/#{cep}/json") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded_body} = Poison.decode(body)
        if cep_not_found?(decoded_body) do
          cep_not_found
        else
          {:ok, format_result_json(decoded_body)}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp cep_not_found?(body) do
    Map.get(body, "erro", false) == true
  end
end
