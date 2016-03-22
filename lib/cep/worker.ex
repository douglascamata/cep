defmodule Cep.Worker do
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
    {:reply, Cep.Client.get_address(cep, options), state}
  end
end
