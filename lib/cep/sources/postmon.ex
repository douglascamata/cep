defmodule Cep.Sources.Postmon do
  import Cep.Sources.Base

  @behaviour Cep.Source
  @url "http://api.postmon.com.br/v1/cep/"

  def get_address(cep) do
    case HTTPoison.get("#{@url}/#{cep}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, result_map} = Poison.decode(body)

        address =
          result_map
          |> translate_keys
          |> Cep.Address.new()

        {:ok, address}

      # For some reason Poison is returns 503 and it
      # returns { :ok, %{ status_code: 503 } }
      {:ok, %HTTPoison.Response{}} ->
        cep_not_found_error()

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
