defmodule Program4Web.MiscComponents do
    use Phoenix.Component

    def person_view(assigns) do
      ~H"""
      <i>
        <div>Email: {@email}</div>
        <div>Name: {@name}</div>
        <div>
          <div>Address:</div>
          <div class="ml-2">
            <div>First line: {@address[:firstLine]}</div>
            <div>City: {@address[:city]}</div>
            <div>State: {@address[:state]}</div>
            <div>Zip: {@address[:zip]}</div>
          </div>
        </div>
      </i>
      """
    end
end
