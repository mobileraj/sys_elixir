defmodule Service1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :application.load(:mnesia)
    children = [
      Service1Web.Telemetry,
      {DNSCluster, query: Application.get_env(:service1, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Service1.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Service1.Finch},
      # Start a worker by calling: Service1.Worker.start_link(arg)
      # {Service1.Worker, arg},
      # Start to serve requests, typically the last entry
      Service1Web.Endpoint
    ]

    Service1.setup()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Service1.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_state) do
    Service1.close()
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Service1Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
