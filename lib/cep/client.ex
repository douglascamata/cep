defmodule Cep.Client do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def get_address(cep, options \\ []) do
    GenServer.call(__MODULE__, {:get_address, cep, options})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:get_address, cep, options}, _from, state) do
    sources = process_sources(options)
    {:reply, get_address_from_multiple_sources(cep, sources), state}
  end

  defp process_sources(options) do
    source = Keyword.get(options, :source, nil)
    if source do
      [source]
    else
      Keyword.get(options, :sources, used_sources)
    end
  end

  def used_sources do
    Application.get_env(:cep, :sources, all_sources)
  end

  def all_sources do
    Keyword.keys(sources_clients_map)
  end

  defp get_address_from_multiple_sources(_, []) do
    {:not_found, "CEP not found."}
  end

  defp get_address_from_multiple_sources(cep, sources) do
    source = List.first(sources)
    client = sources_clients_map[source]
    case client.get_address(cep) do
      {:ok, address} ->
        {:ok, address}
      {:not_found, _} ->
        get_address_from_multiple_sources(cep, List.delete(sources, source))
    end
  end

  defp sources_clients_map do
    [
      correios: Cep.Sources.Correios,
      viacep: Cep.Sources.ViaCep,
      postmon: Cep.Sources.Postmon
    ]
  end
end
