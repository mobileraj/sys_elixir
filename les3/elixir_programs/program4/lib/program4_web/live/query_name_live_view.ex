defmodule Program4Web.QueryNameLiveView do
  use Phoenix.LiveView

  import Program4Web.CoreComponents
  import Program4Web.MiscComponents

  def render(assigns) do
    assigns = assigns
      |> assign_new(:result, fn -> nil end)
      |> assign_new(:form, fn -> to_form(%{}) end)

    ~H"""
    <div>
      <.form for={@form} phx-submit="query">
        <.input field={@form[:queryInput]} label="Name:"/>
        <.button type="submit">Query</.button>
      </.form>
      <%= if @result do %>
        <div>Result: {@result}</div>
        <%= if length(@result) > 0 do %>
          <ul>
            <%= for person <- @result do %>
              <.person_view {person} />
            <% end %>
          </ul>
        <% else %>
          None
        <% end %>
      <% end %>
    </div>
    """
  end

  def handle_event("query", %{"queryInput" => queryInput}, socket) do
    case Program4.queryBy(name: queryInput) do
      {:atomic, data} ->
        {
          :noreply,
          socket
            |> assign(:result,
              case encodeRecord(data) do
                {:ok, json} -> json
                {:error, reason} -> "ERROR: #{reason}"
              end
            )
        }
      {:aborted, _reason} ->
        {:noreply, socket}
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
