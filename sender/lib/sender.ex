defmodule Sender do

  def notity_all(emails) do
    Enum.each(emails, &send_email/1)
  end

  def send_email(email) do
    Process.sleep(3000)
    IO.puts("Email to #{email} sent")
    {:ok, :email_sent}
  end
end
