defmodule UshoWeb.APIController do
  use UshoWeb, :controller
  use PhoenixSwagger
  @version Mix.Project.config()[:version]

  def swagger_definitions do
    %{
      UshoURL:
        swagger_schema do
          title("Shortened URL container.")

          properties do
            url(:string, "URL", required: true)
          end
        end,
      UshoUrlHistoryHitHeadersRecord:
        swagger_schema do
          title("Shortened URL history record.")

          properties do
            header(:string, "header", required: true)
            header_value(:string, "header_value", required: true)
          end
        end,
      UshoUrlHistoryRecord:
        swagger_schema do
          title("Shortened URL history record.")

          property(:timestamp, :string, "timestamp", required: true)
          property(:headers, Schema.array(:UshoUrlHistoryHitHeadersRecord))
        end,
      UshoURLStats:
        swagger_schema do
          title("Hits statistics for a shortened URL.")
          property(:stats, Schema.array(:UshoUrlHistoryRecord))
        end
    }
  end

  swagger_path :create do
    post("/api/create")
    summary("Register a URL")
    description("Takes a URL and saves it in the database.")
    # produces "text/plain"
    parameters do
      url(:query, :string, "URL", required: true)
    end

    response(200, "Ok", Schema.ref(:UshoURL))
    response(404, "Invalid URL")
  end

  def create(conn, %{"url" => url}) do
    with {:ok, signature} <- Usho.put_url(url) do
      json(conn, %{"url" => "/" <> signature})
    else
      {:error, _error} -> send_resp(conn, 404, "Invalid URL")
    end
  end

  swagger_path :get_stats do
    post("/api/get_stats")
    summary("Returns hits statistics for a given URL signature")
    # produces "text/plain"
    parameters do
      signature(:query, :string, "URL signature", required: true)
    end

    response(200, "Ok", Schema.ref(:UshoURLStats))
    response(404, "Invalid URL")
  end

  def get_stats(conn, %{"signature" => signature}) do
    with {:ok, stats} <- Usho.get_url_stats(signature) do
      json(conn, %{"stats" => stats})
    else
      {:error, _error} -> send_resp(conn, 404, "Invalid URL")
    end
  end

  swagger_path :ping do
    get("/api/ping")
    summary("Pings the API server")
    description("Returns 'pong' if the server is operational.")
    produces("text/plain")
    response(200, "Ok")
  end

  def ping(conn, _params) do
    text(conn, "pong")
  end

  swagger_path :log do
    get("/api/log")
    summary("Returns 100 most recent server log records in JSON")
    description("Log is instrumented by RingLogger.")
    response(200, "Ok")
  end

  def log(conn, _params) do
    # Jason and Poison fail to encode the RingLogger response
    {:ok, response} = JSON.encode(RingLogger.get())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  swagger_path :metrics do
    get("/api/metrics")
    summary("Returns metrics")
    description("Metrics are collected by Alchemetrics.")
    response(200, "Ok")
  end

  def metrics(conn, _params) do
    # Metrics are being accumulated in :metrics Agent.
    json(conn, Agent.get(:metrics, fn state -> state end))
  end

  swagger_path :version do
    get("/api/version")
    summary("Returns API version")
    produces("text/plain")
    response(200, "Ok")
  end

  def version(conn, _params) do
    text(conn, @version)
  end
end
