defmodule Sender do

  def notity_all(emails) do
    emails
    |> Enum.map(fn email ->
      Task.async(fn ->  send_email(email) end)
    end)
    |> Enum.map(&Task.yield/1)
  end

  def send_email(email) do
    Process.sleep(3000)
    IO.puts("Email to #{email} sent")
    {:ok, :email_sent}
  end
end
