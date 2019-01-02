defmodule Usho.Redis.Supervisor do
	use Supervisor
	require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    pool_options = [
      name: {:local, :RedisWorkerPool},
      worker_module: Usho.Redis.Worker,
      size: 5,
      max_overflow: 32
    ]

    children = [
      :poolboy.child_spec(:RedisWorkerPool, pool_options, [])
    ]
    supervise(children, strategy: :one_for_one)
  end

  def query(args) do
    :poolboy.transaction(:RedisWorkerPool, fn(worker) -> GenServer.call(worker, %{command: :query, params: args}) end)
  end

end



