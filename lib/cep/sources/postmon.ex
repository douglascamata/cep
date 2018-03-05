defmodule Cep.Sources.Postmon do
  import Cep.Sources.Base

  @behaviour Cep.Source

  def get_address(cep) do
    case HTTPoison.get("http://api.postmon.com.br/v1/cep/#{cep}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, result_map} = Poison.decode(body)

        address =
          result_map
          |> translate_keys
          |> Cep.Address.new()

        {:ok, address}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        cep_not_found_error()

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
