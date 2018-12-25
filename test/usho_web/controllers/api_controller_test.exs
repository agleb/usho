defmodule Usho.ControllersTest do
  use UshoWeb.ConnCase
  require Logger

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert response(conn, 404) == ""
  end

  test "POST /api/create", %{conn: conn} do
    conn = post(conn, "/api/create",%{"url" => "http://elixirforum.com"})
    assert is_binary(response(conn, 200))
  end

  test "GET /*path", %{conn: conn} do
    {:ok, signature} = Usho.put_url("http://elixirforum.com")
    conn = get(conn, "/" <> signature)
    assert html_response(conn, 302) == "<html><body>You are being <a href=\"http://elixirforum.com\">redirected</a>.</body></html>"
  end

  test "GET /api/version", %{conn: conn} do
    conn = get(conn, "/api/version")
    assert response(conn, 200) == "0.1.0"
  end

end
