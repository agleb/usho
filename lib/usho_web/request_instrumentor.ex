defmodule RequestInstrumentor do
  @behaviour Plug

  @moduledoc """

  A plug to collect the raw data for Alchemetrics

  """

  def init(opts \\ []), do: opts
  def call(conn, _opts), do: count_request(conn)

  defp count_request(conn) do
    start = System.monotonic_time()

    Plug.Conn.register_before_send(conn, fn conn ->
      stop = System.monotonic_time()
      diff = System.convert_time_unit(stop - start, :native, :micro_seconds)
      # report throughput
      Alchemetrics.increment(
        request_count: %{method: conn.method, path: conn.request_path, status: conn.status}
      )

      # report request time
      Alchemetrics.report(diff, request_time: %{method: conn.method, path: conn.request_path})
      conn
    end)
  end
end
