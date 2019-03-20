defmodule StreamlabsIntroWeb.Router do
  use StreamlabsIntroWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {StreamlabsIntroWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]

  end

  scope "/", StreamlabsIntroWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", PageController, :login
    live "/counter", PageLive
    get "/stream/:streamer", PageController, :stream
  end

  scope "/api", StreamlabsIntroWeb do
    get "/:event/:id", ApiController, :confirm
    post "/:event/:id", ApiController, :send
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreamlabsIntroWeb do
  #   pipe_through :api
  # end
end
