defmodule Cep.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    pool_custom_config = Application.get_env(:cep, :pool, [])
    pool_size = Keyword.get(pool_custom_config, :size, 5)
    pool_overflow = Keyword.get(pool_custom_config, :overflow, 5)

    poolboy_config = [
      {:name, {:local, :cep_client}},
      {:worker_module, Cep.Worker},
      {:size, pool_size},
      {:max_overflow, pool_overflow}
    ]

    children = [
      :poolboy.child_spec(:cep_client, poolboy_config, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
