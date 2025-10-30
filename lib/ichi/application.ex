defmodule Ichi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      IchiWeb.Telemetry,
      Ichi.Repo,
      {DNSCluster, query: Application.get_env(:ichi, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ichi.PubSub},
      # Start a worker by calling: Ichi.Worker.start_link(arg)
      # {Ichi.Worker, arg},
      # Start to serve requests, typically the last entry
      IchiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ichi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IchiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
