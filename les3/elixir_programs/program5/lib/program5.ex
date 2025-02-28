defmodule Program5 do
  alias GoogleApi.Firestore.V1.Api.Projects
  alias GoogleApi.Firestore.V1.Connection
  alias GoogleApi.Firestore.V1.Model.BeginTransactionResponse
  alias GoogleApi.Firestore.V1.Model.Document
  alias GoogleApi.Firestore.V1.Model.Value
  alias GoogleApi.Firestore.V1.Model.MapValue
  alias GoogleApi.Firestore.V1.Model.RunQueryRequest
  alias GoogleApi.Firestore.V1.Model.CollectionSelector
  alias GoogleApi.Firestore.V1.Model.StructuredQuery
  alias GoogleApi.Firestore.V1.Model.Filter
  alias GoogleApi.Firestore.V1.Model.FieldFilter
  alias GoogleApi.Firestore.V1.Model.FieldReference
  alias GoogleApi.Firestore.V1.Model.TransactionOptions
  alias GoogleApi.Firestore.V1.Model.ReadOnly


  # Much of the code was taken from:
  # https://github.com/TylerSustare/phx_fire
  defp databasePath, do: "projects/elixir-les3-8ef3c/databases/(default)"
  defp documentsPath, do: "#{databasePath()}/documents/people/"

  def setup, do: nil
  def close, do: nil

  defp begin_transaction(conn) do
    Projects.firestore_projects_databases_documents_begin_transaction(
      conn,
      databasePath()
    )
    |> case do
      {:ok, %BeginTransactionResponse{transaction: transaction}} ->
        {:ok, transaction}

      error ->
        IO.inspect(error, pretty: true)
        {:error, :begin_transaction_failure}
    end
  end

  defp prepare_commit_request(document, transaction) do
    request = %GoogleApi.Firestore.V1.Model.CommitRequest{
      transaction: transaction,
      writes: [
        %GoogleApi.Firestore.V1.Model.Write{
          update: document
        }
      ]
    }

    {:ok, request}
  end

  defp commit(conn, request) do
    Projects.firestore_projects_databases_documents_commit(
      conn,
      databasePath(),
      body: request
    )
    |> case do
      {:ok, _} ->
        {:ok, :delivery_details_persisted}

      error ->
        IO.inspect(error, pretty: true)
        {:error, :delivery_details_persistance_failure}
    end
  end

  def writePerson(person) do
    document = %Document{
        name:
          "#{documentsPath()}#{person["email"]}",
        fields: %{
          "email" => %Value{
            stringValue: person["email"]
          },
          "name" => %Value{
            stringValue: person["name"]
          },
          "address" => %Value{
            mapValue: %MapValue{
              fields: %{
                "firstLine" => %Value{
                  stringValue: person["address"]["firstLine"]
                },
                "state" => %Value{
                  stringValue: person["address"]["state"]
                },
                "city" => %Value{
                  stringValue: person["address"]["city"]
                },
                "zip" => %Value{
                  stringValue: person["address"]["zip"]
                },
              }
            }
          },
        }
      }
    with {:ok, token} <- Goth.fetch(PhxFire.Goth),
      conn <- Connection.new(token.token),
      {:ok, transaction} <- begin_transaction(conn),
      {:ok, request} <- prepare_commit_request(document, transaction),
      {:ok, :delivery_details_persisted} <- commit(conn, request) do
        {:ok, person}
      end
  end

  def readByEmail(queryInput) do
    IO.puts "reading by email"
    with {:ok, token} <- Goth.fetch(PhxFire.Goth),
      conn <- Connection.new(token.token),
      res <- Projects.firestore_projects_databases_documents_get(conn, "#{documentsPath()}#{queryInput}") do
        case res do
          {:ok, data} -> {:ok, [documentToPersonRecord(data)]}
          {:error, %{status: 404}} ->
            {:ok, []} #not found --> return :ok
          {:error, info} ->
            {:error, info.status}
        end
      end
  end

  def queryBy(opts \\ []) do
    with {:ok, token} <- Goth.fetch(PhxFire.Goth),
      conn <- Connection.new(token.token),
      res <- gatherResults(conn, (opts[:name] && %FieldFilter{
                  :field => %FieldReference{
                    :fieldPath => "name"
                  },
                  :op => "EQUAL",
                  :value => %Value{ :stringValue => opts[:name]},
                }) ||
              (opts[:state] &&  %FieldFilter{
                  :field => %FieldReference{
                    :fieldPath => "address.state"
                  },
                  :op => "EQUAL",
                  :value => %Value{ :stringValue => opts[:state]},
                })
        ) do
          case res do
            {:ok, [_ | data]} ->
              # IO.inspect(res, pretty: true)
              {:ok, (data || [])
                |> Enum.filter(&(&1 && &1.document))
                |> Enum.map(&(documentToPersonRecord(&1.document)))}
            {:error, info} ->
              IO.inspect(info, pretty: true)
              {:error, "Something went wrong"}
          end
      end
  end

  defp gatherResults(conn, fieldFilter) do
    Projects.firestore_projects_databases_documents_run_query(conn, "#{databasePath()}/documents/",
        body: %RunQueryRequest{
          :structuredQuery => %StructuredQuery{
              :from => %CollectionSelector{
                :collectionId => "people"
              },
              :where => %Filter{
                :fieldFilter => fieldFilter
              },
            },
            :newTransaction => %TransactionOptions{
              :readOnly => %ReadOnly{}
            }
          }
        )
  end

  defp documentToPersonRecord(%{:fields => data}) do
    {
      :person,
      data["email"] && data["email"].stringValue,
      data["name"] && data["name"].stringValue,
      data["address"] && personAddressToMap(data["address"].mapValue),
    }
  end

  defp personAddressToMap(%{:fields => data}) do
    %{
      "firstLine" => data["firstLine"].stringValue,
      "state" => data["state"].stringValue,
      "city" => data["city"].stringValue,
      "zip" => data["zip"].stringValue,
    }
  end
end
