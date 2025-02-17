defmodule Program4.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :application.load(:mnesia)
    children = [
      Program4Web.Telemetry,
      {DNSCluster, query: Application.get_env(:program4, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Program4.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Program4.Finch},
      # Start a worker by calling: Program4.Worker.start_link(arg)
      # {Program4.Worker, arg},
      # Start to serve requests, typically the last entry
      Program4Web.Endpoint
    ]

    Program4.setup()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Program4.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_) do
    Program4.close()
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Program4Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
