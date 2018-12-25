defmodule Usho do
  require Logger
  # TTL for shortened URLs
  @ttl 86_400 * 30

  @moduledoc """

  Usho is a URL shortener.

  """
  defp validate_url(url) when is_binary(url) do
    uri = URI.parse(url)
    uri.scheme != nil && uri.host =~ "."
  end

  defp validate_signature(signature) when is_binary(signature) do
    with match when match != nil <- Regex.run(~R/[A-Za-z0-9]{1,}/, signature),
         true <- signature == Enum.at(match, 0) do
      true
    else
      _ -> false
    end
  end

  def put_url(url) when is_binary(url) do
    case validate_url(url) do
      true ->
        id = get_new_id()
        Usho.Redis.Supervisor.query(["SET", id, url])
        Usho.Redis.Supervisor.query(["EXPIRE", id, @ttl])
        {:ok, id}

      false ->
        {:error, :invalid_url}
    end
  end

  def get_url(signature, params)
      when is_binary(signature) and is_map(params) and params == %{} do
    with true <- validate_signature(signature),
         url when url != "" and url != :undefined <-
           Usho.Redis.Supervisor.query(["GET", signature]) do
      {:ok, url}
    else
      false -> {:error, :invalid_signature}
      _ -> {:error, :not_found}
    end
  end

  def get_url(signature, params) when is_binary(signature) and is_map(params) do
    with true <- validate_signature(signature),
         url when url != "" and url != :undefined <-
           Usho.Redis.Supervisor.query(["GET", signature]) do
      {:ok, apply_params(url, params)}
    else
      false -> {:error, :invalid_signature}
      _ -> {:error, :not_found}
    end
  end

  def get_url(_signature, _params) do
    {:error, :not_found}
  end

  @spec get_url_stats(binary()) :: {:error, :invalid_signature} | {:ok, [any()]}
  def get_url_stats(signature) when is_binary(signature) do

    with true <- validate_signature(signature),
         stats <- Usho.Redis.Supervisor.query(["LRANGE", signature <> "_history", 0, 2000]) do
      result =
        Enum.map(stats, fn item ->
          [ts, headers_json] = String.split(item, ";", parts: 2)

          headers =
            case JSON.decode(headers_json) do
              {:ok, headers} -> headers
              _ -> ""
            end

          %{"timestamp" => ts, "headers" => headers}
        end)

      {:ok, result}
    else
      false -> {:error, :invalid_signature}
      _ -> {:error, :not_found}
    end
  end

  def register_hit(signature, headers) when is_binary(signature) and is_binary(headers) do
    with "1" <- Usho.Redis.Supervisor.query(["EXPIRE", signature, @ttl]),
         history_length <-
           Usho.Redis.Supervisor.query([
             "LPUSH",
             signature <> "_history",
             to_string(:os.system_time()) <> ";" <> headers
           ]) do
      {:ok, history_length}
    else
      error -> {:error, error}
    end
  end

  def get_new_id() do
    Usho.Redis.Supervisor.query(["INCR", "USHO_AUTOINCREMENT"])
    |> String.to_integer()
    |> Usho.HashID.get()
  end

  def apply_params(url, params) when is_map(params) and params != %{} do
    Regex.scan(~R/[\?\&]+?\w+?\=\<\%(\w+)\%\>[&\z]+/, url)
    |> Enum.reduce(url, fn [_, anchor], acc ->
      String.replace(acc, "<%" <> anchor <> "%>", Map.get(params, anchor))
    end)
  end
end
