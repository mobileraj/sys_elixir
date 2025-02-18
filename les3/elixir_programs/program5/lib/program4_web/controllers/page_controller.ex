defmodule Program5Web.PageController do
  use Program5Web, :controller

  import Phoenix.LiveView.Controller

  plug :put_layout, false

  def home(conn, _params), do:
    render(conn, :home)

  def query_email(conn, _params), do:
    live_render(conn, Program5Web.QueryEmailLiveView)

  def query_name(conn, _params), do:
    live_render(conn, Program5Web.QueryNameLiveView)

  def query_state(conn, _params), do:
    live_render(conn, Program5Web.QueryStateLiveView)

  def create_person(conn, _params), do:
    live_render(conn, Program5Web.CreatePersonLiveView)
end
