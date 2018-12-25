defmodule Usho.StatsWorker do
  use GenServer
  require Exredis
  require Logger

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, name: __MODULE__)
  end

  def init(conn) do
    {:ok, conn}
  end

  def save_stats(signature, timestamp, headers)
      when is_binary(signature) and is_integer(timestamp) and is_binary(headers) do
    Process.send(__MODULE__, {:save_stats, signature, timestamp, headers}, [])
  end

  @doc false
  def handle_info(msg, conn) do
    conn = ensure_connection(conn)

    case msg do
      {:save_stats, signature, timestamp, headers} ->
        query(conn, [
          "LPUSH",
          signature <> "_history",
          to_string(timestamp) <> ";" <> headers
        ])

        {:noreply, conn}

      msg ->
        Logger.debug(inspect(msg))
        {:noreply, conn}
    end
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
