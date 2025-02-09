defmodule Service2Web.Router do
  use Service2Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Service2Web do
    pipe_through :api
    post "/log", LoggerAPI, :log
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:service2, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
