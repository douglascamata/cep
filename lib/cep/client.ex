defmodule Cep.Client do
  @moduledoc """
    Provides a function `get_address/1` to query addreses of a given cep.
  """

  @doc """
  Gets the address related to a given CEP.

  ## Parameters

    - cep: The CEP code

  ## Return value

    It returns a Cep.Address when the CEP was found.

  ### Errors

    It returns a tuple `{:not_found, "CEP not found."}` if the CEP couldn't be
    found in any of the sources (probably an invalid CEP).

    It returns a tuple `{:error, reason}` in case there was an unhandled error
    coming from the source.
  """
  def get_address(cep, options \\ []) do
    sources = process_sources(options)
    get_address_from_multiple_sources(cep, sources, error: false, reason: nil)
  end

  defp process_sources(options) do
    source = Keyword.get(options, :source, nil)

    if source do
      [source]
    else
      Keyword.get(options, :sources, used_sources())
    end
  end

  def used_sources do
    Application.get_env(:cep, :sources, all_sources())
  end

  def all_sources do
    Keyword.keys(sources_clients_map())
  end

  defp get_address_from_multiple_sources(_, [], error: false, reason: _) do
    {:not_found, "CEP not found."}
  end

  defp get_address_from_multiple_sources(_, [], error: true, reason: reason) do
    {:error, reason}
  end

  defp get_address_from_multiple_sources(cep, sources, error: _, reason: _) do
    source = List.first(sources)
    client = sources_clients_map()[source]

    case client.get_address(cep) do
      {:ok, address} ->
        {:ok, address}

      {:not_found, _} ->
        get_address_from_multiple_sources(
          cep,
          List.delete(sources, source),
          error: false,
          reason: nil
        )

      {:error, reason} ->
        get_address_from_multiple_sources(
          cep,
          List.delete(sources, source),
          error: true,
          reason: reason
        )
    end
  end

  defp sources_clients_map do
    sources = [
      correios: Cep.Sources.Correios,
      viacep: Cep.Sources.ViaCep,
      postmon: Cep.Sources.Postmon
    ]

    if Application.get_env(:cep, :env) == :test do
      sources
      |> Keyword.put_new(:dummy, Cep.Sources.Test.Dummy)
      |> Keyword.put_new(:alternative, Cep.Sources.Test.Alternative)
      |> Keyword.put_new(:unavailable, Cep.Sources.Test.Unavailable)
    else
      sources
    end
  end
end
