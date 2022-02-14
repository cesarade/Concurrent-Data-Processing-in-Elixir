defmodule Sender do

  def notity_all(emails) do
    emails
    |> Task.async_stream(&send_email/1)
    |> Enum.to_list()
  end

  def send_email(email) do
    Process.sleep(3000)
    IO.puts("Email to #{email} sent")
    {:ok, :email_sent}
  end
end
