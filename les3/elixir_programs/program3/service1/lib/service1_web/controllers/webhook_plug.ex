defmodule Service1Web.WebhookPlug do
  def init(params), do: params
  def call(%Plug.Conn{} = conn, _params) do
    %HTTPoison.Request{
        method: :post,
        url: "http://localhost:4001/api/log",
        headers: [{"Content-Type", "application/json"}],
        body: Jason.encode!(%{
          "method" => conn.method,
          "route" => conn.request_path,
          "params" => conn.params,
        })
    } |> HTTPoison.request
    conn
  end
end
