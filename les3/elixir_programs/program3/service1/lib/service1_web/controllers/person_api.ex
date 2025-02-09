defmodule Service1Web.PersonAPI do
  use Service1Web, :controller

  def getByEmail(conn, params) do
    case Service1.readByEmail(Map.get(params, "email")) do
      {:atomic, data} -> sendData(conn, data)
      {:aborted, reason} -> Plug.Conn.send_resp(conn, 500, "Internal server error: #{reason}")
    end
  end

  def getFiltered(conn, params) do
    case Service1.queryBy(
        state: Map.get(params, "state"),
        name: Map.get(params, "name")
    ) do
      {:atomic, data} -> sendData(conn, data)
      {:aborted, reason} -> Plug.Conn.send_resp(conn, 500, "Internal server error: #{reason}")
    end
  end

  def putPerson(conn, params) do
    email = Map.get(params, "email")
    case Service1.writePerson(Map.put(conn.body_params, "email", email)) do
      {:atomic, _} -> Plug.Conn.send_resp(conn, 201, "OK")
      {:aborted, reason} -> Plug.Conn.send_resp(conn, 500, "Internal server error: #{reason}")
    end
  end

  defp sendData(conn, data) do
    case data |> encodeRecord do
      {:ok, json} -> Plug.Conn.send_resp(conn, 200, json)
      {:error, reason} -> Plug.Conn.send_resp(conn, 500, "Some sorta parsing error: #{reason}")
    end
  end

  defp encodeRecord(data) do
    data |>
      Enum.map(fn {:person, email, name, address} ->
        %{
          "email" => email,
          "name" => name,
          "address" => address
        }
      end) |> Jason.encode
  end
end
