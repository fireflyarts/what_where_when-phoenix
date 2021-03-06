defmodule WhatWhereWhen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Logger.add_backend(Sentry.LoggerBackend)

    children = [
      # Start the Ecto repository
      WhatWhereWhen.Repo,
      # Start the Telemetry supervisor
      WhatWhereWhenWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WhatWhereWhen.PubSub},
      # Start the Endpoint (http/https)
      WhatWhereWhenWeb.Endpoint
      # Start a worker by calling: WhatWhereWhen.Worker.start_link(arg)
      # {WhatWhereWhen.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WhatWhereWhen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WhatWhereWhenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
