defmodule Cep.Sources.ViaCep do
  use Cep.Sources.Base

  @behaviour Cep.Source

  def get_address(cep) do
    case HTTPoison.get("http://viacep.com.br/ws/#{cep}/json") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, result_map} = Poison.decode(body)
        if cep_not_found?(result_map) do
          cep_not_found()
        else
          {:ok, result_map |> translate_keys |> Cep.Address.new}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp cep_not_found?(body) do
    Map.get(body, "erro", false)
  end
end
