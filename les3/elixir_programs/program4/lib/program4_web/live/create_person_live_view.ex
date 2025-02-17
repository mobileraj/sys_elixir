defmodule Program4Web.CreatePersonLiveView do
  use Phoenix.LiveView

  import Program4Web.CoreComponents

  def render(assigns) do
    assigns = assigns
      |> assign_new(:form, fn -> to_form(%{}) end)

    ~H"""
    <.flash_group flash={@flash} />
    <.form for={@form} phx-submit="put-person">
      <.input field={@form[:email]} label="Email:"/>
      <.input field={@form[:name]} label="Name:"/>
      <div>Address:</div>
      <div class="ml-2">
        <.input field={@form[:addressFirstLine]} label="First Line:"/>
        <.input field={@form[:addressCity]} label="City"/>
        <.input field={@form[:addressState]} label="State"/>
        <.input field={@form[:addressZip]} label="Zip"/>
      </div>
      <.button type="submit">Submit</.button>
    </.form>
    """
  end

  def handle_event("put-person",
    %{
      "email" => email,
      "name" => name,
      "addressFirstLine" => addressFirstLine,
      "addressCity" => addressCity,
      "addressState" => addressState,
      "addressZip" => addressZip,
    }, socket)
  do
    {:noreply, socket}
    case Program4.writePerson(%{
      "email" => email,
      "name" => name,
      "address" => %{
        "firstLine" => addressFirstLine,
        "city" => addressCity,
        "state" => addressState,
        "zip" => addressZip,
      }
    }) do
      {:atomic, _} ->
        {:noreply, socket |> put_flash(:info, "Success!")}
      {:aborted, reason} ->
        {:noreply, socket |> put_flash(:error, "Error: #{reason}")}
    end
  end

end
