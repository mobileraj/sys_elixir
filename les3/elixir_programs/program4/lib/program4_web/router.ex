defmodule Program4Web.Router do
  use Program4Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Program4Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Program4Web do
    pipe_through :browser

    get "/", PageController, :home
    get "/query-email", PageController, :query_email
    get "/query-name", PageController, :query_name
    get "/query-state", PageController, :query_state
    get "/create-person", PageController, :create_person
  end

  # Other scopes may use custom stacks.
  # scope "/api", Program4Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:program4, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Program4Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
