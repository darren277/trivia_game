defmodule TriviaGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TriviaGameWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:trivia_game, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TriviaGame.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TriviaGame.Finch},
      # Start a worker by calling: TriviaGame.Worker.start_link(arg)
      # {TriviaGame.Worker, arg},
      # Start to serve requests, typically the last entry
      TriviaGameWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TriviaGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TriviaGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
