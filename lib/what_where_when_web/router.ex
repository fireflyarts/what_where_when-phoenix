defmodule WhatWhereWhenWeb.Router do
  use WhatWhereWhenWeb, :router

  import WhatWhereWhenWeb.PersonAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WhatWhereWhenWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_person
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WhatWhereWhenWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WhatWhereWhenWeb do
  #   pipe_through :api
  # end

  if Mix.env() === :dev do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WhatWhereWhenWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", WhatWhereWhenWeb do
    pipe_through [:browser, :redirect_if_person_is_authenticated]

    get "/people/register", PersonRegistrationController, :new
    post "/people/register", PersonRegistrationController, :create
    get "/people/log_in", PersonSessionController, :new
    post "/people/log_in", PersonSessionController, :create
    get "/people/reset_password", PersonResetPasswordController, :new
    post "/people/reset_password", PersonResetPasswordController, :create
    get "/people/reset_password/:token", PersonResetPasswordController, :edit
    put "/people/reset_password/:token", PersonResetPasswordController, :update
  end

  scope "/", WhatWhereWhenWeb do
    pipe_through [:browser, :require_authenticated_person]

    get "/people/settings", PersonSettingsController, :edit
    put "/people/settings", PersonSettingsController, :update
    get "/people/settings/confirm_email/:token", PersonSettingsController, :confirm_email
  end

  scope "/", WhatWhereWhenWeb do
    pipe_through [:browser]

    delete "/people/log_out", PersonSessionController, :delete
    get "/people/confirm", PersonConfirmationController, :new
    post "/people/confirm", PersonConfirmationController, :create
    get "/people/confirm/:token", PersonConfirmationController, :edit
    post "/people/confirm/:token", PersonConfirmationController, :update
  end
end
