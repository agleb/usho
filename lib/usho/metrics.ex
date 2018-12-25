defmodule Usho.Metrics do
  use Alchemetrics.CustomBackend
  use Agent

  @moduledoc """
  Alchemetrics custom backend.
  The data is stored in the :metrics Agent.
  """

  def init(options) do
    {:ok, options}
  end

  def start_link() do
    Agent.start_link(fn -> %{} end, name: :metrics)
  end

  def report(metadata, datapoint, value, options) do
    metadata = Enum.into(metadata, %{})
    base_report = %{datapoint: datapoint, value: value, options: options}

    Agent.update(:metrics, fn state ->
      Map.put(state, datapoint, Map.merge(base_report, metadata))
    end)

    {:ok, options}
  end
end
