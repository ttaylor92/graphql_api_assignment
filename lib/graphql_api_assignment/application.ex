defmodule GraphqlApiAssignment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: GraphqlApiAssignment.PubSub},
      {DNSCluster,
       query: Application.get_env(:graphql_api_assignment, :dns_cluster_query) || :ignore},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GraphqlApiAssignment.Finch},
      # Start a worker by calling: GraphqlApiAssignment.Worker.start_link(arg)
      # {GraphqlApiAssignment.Worker, arg},
      # Start to serve requests, typically the last entry
      GraphqlApiAssignmentWeb.Endpoint,
      {Absinthe.Subscription, GraphqlApiAssignmentWeb.Endpoint},
      GraphqlApiAssignment.Repo,
      GraphqlApiAssignmentWeb.ResolverBucket
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlApiAssignment.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlApiAssignmentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
