defmodule Program4Web.MiscComponents do
    use Phoenix.Component

    def person_view(person) do
      assigns = person
      ~H"""
      <div>
        <div>Email: {@email}</div>
        <div>Name: {@name}</div>
        <div>
          <div>Address:</div>
          <div class="ml-2">
            <div>First line: {Map.get(@address, "firstLine")}</div>
            <div>City: {Map.get(@address, "city")}</div>
            <div>State: {Map.get(@address, "state")}</div>
            <div>Zip: {Map.get(@address, "zip")}</div>
          </div>
        </div>
      </div>
      """
    end
end
