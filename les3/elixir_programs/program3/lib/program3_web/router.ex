defmodule Program3Web.Router do
  use Program3Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Program3Web do
    pipe_through :api

    get "/person", PersonAPI, :hello
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:program3, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

defmodule Program3Web.PersonAPI do
  use Program3Web, :controller

  def hello(%Plug.Conn{} = conn, params) do
    Plug.Conn.send_resp(conn, 200, "Woop Woop yeah lets go man!");
  end
end
