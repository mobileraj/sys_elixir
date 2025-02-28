defmodule Program5.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    goth_source =
      "GOOGLE_APPLICATION_CREDENTIALS_JSON"
      |> System.fetch_env!()
      |> Jason.decode!()
      |> (&{:service_account, &1}).()

    children = [
      Program5Web.Telemetry,
      {DNSCluster, query: Application.get_env(:program5, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Program5.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Program5.Finch},
      # Start a worker by calling: Program5.Worker.start_link(arg)
      # {Program5.Worker, arg},
      {Goth, name: PhxFire.Goth, source: goth_source},
      # Start to serve requests, typically the last entry
      Program5Web.Endpoint
    ]

    Program5.setup()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Program5.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_) do
    Program5.close()
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Program5Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
