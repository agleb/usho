defmodule UshoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :usho
  plug CORSPlug, origin: ["http://localhost:4000","http://usho:4000", "http://127.0.0.1:4000"]
  plug RequestInstrumentor

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_usho_key",
    signing_salt: "aBdiOHYD"

  plug UshoWeb.Router
end
