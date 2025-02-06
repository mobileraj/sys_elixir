
defmodule Mix.Tasks.Main do
  use Mix.Task


  def run(argv) do
    setupDB();
    with {_, [filepath], _} <- OptionParser.parse(argv, strict: []),
          {:ok, rawData} <- File.read(filepath),
          {:ok, parsedData} <- JSON.decode(rawData) do
      :mnesia.transaction fn ->
        :mnesia.write_lock_table(:person);
        for %{"email" => email, "name" => name, "address" => address} <- parsedData,
          do: :mnesia.write({:person, email, name, address})
      end
    end

    prompt =
      "Commands:\n" <>
      "  (q)uit\n" <>
      "  query by (n)ame\n" <>
      "  query by (e)mail\n" <>
      "  query by (s)tate\n" <>
      "Enter command:";
    commandLoop prompt,
    fn
      "q" -> :quit
      "n" ->
        queryByName() |> displayResults
        :loop
      "e" ->
        queryByEmail() |> displayResults
        :loop
      "s" ->
        queryByState() |> displayResults
        :loop
      _ -> :invalid
    end

    :mnesia.stop()
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
      :mnesia.read {:person, queryInput}
    end
  end
  def queryByState do
    IO.puts("Enter state (two letters):")
    queryInput = IO.read(:line) |> String.trim
    :mnesia.transaction fn ->
      :mnesia.match_object {:person, :_, :_, %{"state" => queryInput}}
    end
  end
  def displayResults(results) do
    case results do
      {:atomic, []} -> IO.puts("No results found\n")
      {:atomic, data} ->
        IO.puts("Results:")
        for(record <- data, do: stringifyRecord(record))
          |> Enum.join("\n")
          |> IO.puts
        IO.puts("")
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

  def stringifyRecord({:person, email, name, %{
        "firstLine" => firstLine,
        "city" => city,
        "state" => state,
        "zip" => zip}}), do:
    "#{email}:\n" <>
    "  Name: #{name}\n" <>
    "  Address:\n" <>
    "    #{firstLine}\n" <>
    "    #{city}, #{state} #{zip}"

end
