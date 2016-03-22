defmodule Cep do
  use Application

  def start(_type, _args) do
    Cep.Supervisor.start_link
  end

  def all_sources do
    Cep.Client.all_sources
  end

  def used_sources do
    Cep.Client.used_sources
  end

  def get_address(cep, options \\ []) do
    worker = :poolboy.checkout(:cep_client, true, :infinity)
    try do
      GenServer.call(worker, {:get_address, cep, options})
    after
      :poolboy.checkin(:cep_client, worker)
    end
  end

  def test do
    Enum.each(1..5, fn(_) ->
      spawn(
        fn -> Cep.get_address("00000-000")
      end)
    end)
  end
end
