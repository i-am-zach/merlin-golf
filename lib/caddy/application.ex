defmodule Caddy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CaddyWeb.Telemetry,
      Caddy.Repo,
      {DNSCluster, query: Application.get_env(:caddy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Caddy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Caddy.Finch},
      # Start a worker by calling: Caddy.Worker.start_link(arg)
      # {Caddy.Worker, arg},
      # Start to serve requests, typically the last entry
      CaddyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Caddy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CaddyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
