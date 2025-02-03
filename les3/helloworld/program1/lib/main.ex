
defmodule Mix.Tasks.Main do
  use Mix.Task


  def run(argv) do
    __MODULE__.setupDB();
    with {_, [filepath], _} <- OptionParser.parse(argv, strict: []),
          {:ok, rawData} <- File.read(filepath),
          {:ok, parsedData} <- JSON.decode(rawData) do
      :mnesia.transaction fn ->
        :mnesia.write_lock_table(:person);
        for %{"email" => email, "name" => name, "address" => address} <- parsedData,
          do: :mnesia.write({:person, email, name, address})
      end
    end

    prompt = "Commands: \n\t(q)uit\n\tquery by (n)ame\n\tquery by (e)mail\nEnter command:"
    commandLoop prompt,
    fn
      "q" -> :quit
      "n" ->
        queryByName() |> displayResults
        :loop
      "e" ->
        queryByEmail() |> displayResults
        :loop
      _ -> :invalid
    end

    :mnesia.stop()
  end

  def queryByName do
    IO.puts("Enter name:")
    queryInput = IO.read(:line) |> String.trim
    :mnesia.transaction fn ->
      :mnesia.match_object {:person, :_, queryInput, :_}
    end
  end
  def queryByEmail do
    IO.puts("Enter email:")
    queryInput = IO.read(:line) |> String.trim
    :mnesia.transaction fn ->
      :mnesia.match_object {:person, queryInput, :_, :_}
    end
  end
  def displayResults(results) do
    case results do
      {:atomic, []} -> IO.puts("No results found\n")
      {:atomic, data} ->
        IO.puts("Results:")
        for({:person, email, name, address} <- data, do: "#{email}: Name: #{name}, address: #{address}")
          |> Enum.join("\n")
          |> IO.puts
        IO.puts("\n")
      {:aborted, _} -> IO.puts("Aborted")
      {:error, _} -> IO.puts("Error")
    end
end

def commandLoop(query, performCommand) do
  IO.puts(query)
  input = IO.read(:line) |> String.trim |> String.downcase
  case performCommand.(input) do
    :break ->
      IO.puts("Have a wonderful day!")
    :quit ->
      commandLoop "Do you want to save loaded data to disk (y/n)?",
      fn
        "y" ->
          :mnesia.dump_tables([:person])
          :break
        "n" -> :break
        _ -> :invalid
      end
    :invalid ->
      IO.puts("Invalid input, please try again")
      commandLoop(query, performCommand)
    :loop -> commandLoop(query, performCommand)
  end
end

  def setupDB do
    :mnesia.stop()
    :mnesia.create_schema([node()])
    :mnesia.start()
    :mnesia.create_table(:person, [
      disc_copies: [node()],
      attributes: [:email, :name, :address],
    ])
    :mnesia.add_table_index(:person, :name);
    :mnesia.wait_for_tables([:person], 1000)
  end
end
