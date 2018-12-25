defmodule Usho.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      %{id: Usho.Redis.Supervisor, start: {Usho.Redis.Supervisor, :start_link, []}},
      %{id: Usho.HashID, start: {Usho.HashID, :start_link, []}},
      %{id: Usho.StatsWorker, start: {Usho.StatsWorker, :start_link, [nil]}},
      %{id: Usho.Metrics, start: {Usho.Metrics, :start_link, []}},
      UshoWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Usho.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    UshoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
