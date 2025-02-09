defmodule Service1Web.Router do
  use Service1Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Service1Web.WebhookPlug
  end

  scope "/api", Service1Web do
    pipe_through :api

    get "/person/:email/email", PersonAPI, :getByEmail
    get "/person", PersonAPI, :getFiltered
    put "/person/:email", PersonAPI, :putPerson
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:service1, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
