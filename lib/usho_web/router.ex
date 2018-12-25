defmodule UshoWeb.Router do
  use UshoWeb, :router

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :usho, swagger_file: "swagger.json"
  end

  scope "/api", UshoWeb do
    post("/create", APIController, :create)
    post("/get_stats", APIController, :get_stats)
    get("/ping", APIController, :ping)
    get("/log", APIController, :log)
    get("/metrics", APIController, :metrics)
    get("/version", APIController, :version)
  end

  scope "/", UshoWeb do
    get("/*path", MainController, :main)
  end

  def swagger_info do
    %{
      info: %{
        version: "0.1.0",
        title: "Usho"
      }
    }
  end
end
