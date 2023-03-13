defmodule GoodDay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GoodDayWeb.Telemetry,
      # Start the Ecto repository
      GoodDay.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GoodDay.PubSub},
      # Start Finch
      {Finch, name: GoodDay.Finch},
      # Start the Endpoint (http/https)
      GoodDayWeb.Endpoint
      # Start a worker by calling: GoodDay.Worker.start_link(arg)
      # {GoodDay.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GoodDay.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GoodDayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
