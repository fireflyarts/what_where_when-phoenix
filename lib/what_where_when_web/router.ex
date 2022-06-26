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
    plug :fetch_session
    plug :fetch_current_person
  end

  scope "/", WhatWhereWhenWeb do
    pipe_through :browser

    get "/", PageController, :index
    delete "/who/me", PersonSessionController, :delete
    get "/api/auth", PersonSessionController, :create

    get "/what", EventCategoryController, :index
    get "/where", LocationController, :index
    get "/when", EventController, :index
  end

  scope "/", WhatWhereWhenWeb do
    pipe_through [:browser, :redirect_if_person_is_authenticated]
    get "/who/me", PersonSessionController, :new
  end

  scope "/", WhatWhereWhenWeb do
    pipe_through [:browser, :require_authenticated_person]

    resources "/who/camps", CampController, only: [:show]

    resources "/events", EventController, only: [:new, :create, :show]
  end

  scope "/api", WhatWhereWhenWeb do
    pipe_through :api

    get "/event/categories", EventCategoryController, :index
    get "/events", EventController, :index
  end

  if Mix.env() === :dev do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      post "/api/auth", WhatWhereWhenWeb.PersonSessionController, :create
      live_dashboard "/dashboard", metrics: WhatWhereWhenWeb.Telemetry
    end
  end
end

# get "/people/confirm", PersonConfirmationController, :new
# post "/people/confirm", PersonConfirmationController, :create
# get "/people/confirm/:token", PersonConfirmationController, :edit
# post "/people/confirm/:token", PersonConfirmationController, :update

# scope "/", WhatWhereWhenWeb do
#   pipe_through [:browser, :redirect_if_person_is_authenticated]

#   get "/people/register", PersonRegistrationController, :new
#   post "/people/register", PersonRegistrationController, :create

#   get "/people/reset_password", PersonResetPasswordController, :new
#   post "/people/reset_password", PersonResetPasswordController, :create
#   get "/people/reset_password/:token", PersonResetPasswordController, :edit
#   put "/people/reset_password/:token", PersonResetPasswordController, :update
# end

# scope "/", WhatWhereWhenWeb do
#   pipe_through [:browser, :require_authenticated_person]

#   get "/people/settings", PersonSettingsController, :edit
#   put "/people/settings", PersonSettingsController, :update
#   get "/people/settings/confirm_email/:token", PersonSettingsController, :confirm_email
# end
