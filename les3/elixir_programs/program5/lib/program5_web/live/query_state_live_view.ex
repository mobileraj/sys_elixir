defmodule Program5Web.QueryStateLiveView do
  use Phoenix.LiveView

  import Program5Web.CoreComponents
  import Program5Web.MiscComponents
  import Program5.Util

  def render(assigns) do
    assigns = assigns
      |> assign_new(:result, fn -> nil end)
      |> assign_new(:form, fn -> to_form(%{}) end)

    ~H"""
    <div>
      <.form for={@form} phx-submit="query">
        <.input field={@form[:queryInput]} label="State:"/>
        <.button type="submit">Query</.button>
      </.form>
      <%= if @result do %>
        <div>Result:</div>
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
    case Program5.queryBy(state: queryInput) do
      {:ok, data} ->
        {
          :noreply,
          socket
            |> assign(:result, Enum.map(data, &personRecordToAssigns/1))
        }
      {:error, _reason} ->
        {:noreply, socket}
    end
  end

end
