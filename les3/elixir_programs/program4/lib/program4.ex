defmodule Program4 do

  def setup do
    :mnesia.stop()
    :mnesia.create_schema([node()])
    :mnesia.start()

    :mnesia.create_table(:person,
      disc_copies: [node()],
      attributes: [:email, :name, :address]
    )

    :mnesia.add_table_index(:person, :name)
    :mnesia.wait_for_tables([:person], 1000)
  end

  def close do
    :mnesia.dump_tables([:person])
    :mnesia.stop()
  end

  def writePerson(person) do
    %{"email" => email, "name" => name, "address" => address} = person

    :mnesia.transaction(fn ->
      :mnesia.write({:person, email, name, address})
    end)
  end

  def readByEmail(queryInput) do
    :mnesia.transaction(fn ->
      :mnesia.read({:person, queryInput})
    end)
  end

  def queryBy(opts \\ []) do
    :mnesia.transaction(fn ->
      :mnesia.match_object({
        :person,
        :_,
        if(opts[:name], do: opts[:name], else: :_),
        if(opts[:state], do: %{"state" => opts[:state]}, else: :_)
      })
    end)
  end

end
