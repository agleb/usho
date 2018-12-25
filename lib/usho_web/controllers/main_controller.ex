defmodule UshoWeb.MainController do
  require Logger
  use UshoWeb, :controller
  use PhoenixSwagger

  swagger_path :main do
    get("/{signature}")
    summary("Find the signature==path and send 302 redirect to the initial address.")
    description("Replace tokens like <%token%> with the same-named values from GET parameters")
    produces("text/html")

    parameters do
      signature(:path, :string, "signature", required: true)
    end

    response(302, "Ok")
    response(404, "Not found")
  end

  def main(conn, params) do
    signature = params |> Map.get("path") |> List.first()

    with {:ok, url} <- Usho.get_url(signature, Map.delete(params, "path")) do
      {:ok, headers_json} = JSON.encode(conn.req_headers)
      Usho.StatsWorker.save_stats(signature, :os.system_time(), headers_json)
      redirect(conn, external: url)
    else
      _error -> send_resp(conn, 404, "")
    end
  end
end
