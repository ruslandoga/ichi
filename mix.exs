defmodule Ichi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ichi,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      release: [ichi: [include_executables_for: [:unix]]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ichi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:telemetry, "~> 1.3.0"}
    ]
  end
end
