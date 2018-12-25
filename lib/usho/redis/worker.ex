defmodule Usho.Redis.Worker do
  use GenServer
  require Exredis
  require Logger

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, [])
  end

  def init(conn) do
    {:ok, conn}
  end

  @doc false
  def handle_call(%{command: :query, params: params}, _from, conn) do
    conn = ensure_connection(conn)
    {:reply, query(conn, params), conn}
  end

  @doc false
  def query(conn, params) do
    Exredis.query(conn, params)
  end

  defp ensure_connection(conn) when is_pid(conn) do
    if Process.alive?(conn) do
      conn
    else
      Logger.debug("[Connector] redis conn is died, reconnecting...")
      connect()
    end
  end

  defp ensure_connection(_conn) do
    connect()
  end

  defp connect() do
    Exredis.start_using_connection_string(Application.get_env(:usho, :redis_url))
  end
end
