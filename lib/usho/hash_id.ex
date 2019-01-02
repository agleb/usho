defmodule Usho.HashID do
  use Agent

  def start_link() do
    Agent.start_link(fn -> init_state() end, name: :hashid)
  end


  def init_state do
    Hashids.new(
      salt: Application.get_env(:usho, :hashid_salt),
      min_len: 2
    )
  end

  def get(id) when is_integer(id) do
    Agent.get(:hashid, fn state -> state end)
    |> Hashids.encode(id)
  end
end
