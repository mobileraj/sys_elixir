defmodule Service1 do
  @moduledoc """
  Service1 keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

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

  def queryBy([state: state, name: name]),
    do: queryBy([name: name, state: state])

  def queryBy([name: name, state: state]) do
    :mnesia.transaction(fn ->
      :mnesia.match_object({
        :person,
        :_,
        if(name, do: name, else: :_),
        if(state, do: %{"state" => state}, else: :_)
      })
    end)
  end
end
