defmodule Program4.Util do
  def personRecordToAssigns({:person, email, name, address}) do
    %{
      :email => email,
      :name => name,
      :address => %{
        :firstLine => address["firstLine"],
        :city => address["city"],
        :state => address["state"],
        :zip => address["zip"],
      }
    }
  end
end
