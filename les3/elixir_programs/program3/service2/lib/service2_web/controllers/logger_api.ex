defmodule Service2Web.LoggerAPI do
  use Service2Web, :controller

  def log(conn, params) do
    %{
      "method" => method,
      "route" => route,
      "params" => eventParams
    } = params;
    IO.puts "************RESPONDING TO WEBHOOK POST****************\n" <>
    "method: #{method}\n" <>
    "url: #{route}\n" <>
    "params: #{eventParams |> Jason.encode!}\n" <>
    "******************************************************"
    Plug.Conn.send_resp(conn, 200, "OK")
  end
end
