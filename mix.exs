defmodule Usho.MixProject do
  use Mix.Project

  def project do
    [
      app: :usho,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext, :phoenix_swagger] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Usho.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:poolboy, "~> 1.5.1"},
      {:exredis, ">= 0.2.4"},
      {:hashids, "~> 2.0"},
      {:phoenix_swagger, "~> 0.8"},
      {:cors_plug, "~> 1.4"},
      {:ex_json_schema, "~> 0.5"},
      {:json, "~> 1.2"},
      {:alchemetrics, "~> 0.5.2"},
      {:ring_logger, "~> 0.4"}

    ]
  end
end
