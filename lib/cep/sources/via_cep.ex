defmodule Cep.Sources.ViaCep do
  import Cep.Sources.Base

  @behaviour Cep.Source
  @url "http://viacep.com.br/ws/"

  def get_address(cep) do
    case HTTPoison.get("#{@url}/#{cep}/json") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, result_map} = Poison.decode(body)

        if cep_not_found?(result_map) do
          cep_not_found_error()
        else
          {:ok, to_address(result_map)}
        end

      {:ok, %HTTPoison.Response{body: body}} ->
        unknown_error(body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp cep_not_found?(body) do
    Map.get(body, "erro", false)
  end
end
