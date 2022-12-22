defmodule Chat do
  def spawn_task(module, fun, recipient, args) do
    recipient
    |> remote_supervisor()
    |> Task.Supervisor.async(module, fun, args)
    |> Task.await()
  end

  defp remote_supervisor(recipient) do
    {Chat.TaskSupervisor, recipient}
  end

  def send_message(recipient, message) do
    if recipient === :moebi@localhost do
      spawn_task(__MODULE__, :receive_message_for_moebi, :moebi@localhost, [message, Node.self()])
    else
      spawn_task(__MODULE__, :receive_message, recipient, [message])
    end
  end

  def receive_message(message) do
    IO.puts message
  end

  def receive_message_for_moebi(message, from) do
    IO.puts message
    send_message(from, "chicken?")
  end

  def shorten_url(url) do
    if Node.ping(:"tinyurl@localhost") == :pang do
      Node.start(:"tinyurl@localhost")
      IO.puts Node.ping(:"tinyurl@localhost")
      Node.spawn(:"tinyurl@localhost", TinyURL, :start_link, [:foo])
    end
    spawn_task(__MODULE__, :shorten_url_sendback, :"tinyurl@localhost", [url, Node.self()])
  end

  def shorten_url_sendback(url, from) do
    send_message(from, TinyURL.shorten(:foo, url))
  end

  def get_url(hash) do
    spawn_task(__MODULE__, :get_url_sendback, :"tinyurl@localhost", [hash, Node.self()])
  end

  def get_url_sendback(hash, from) do
    send_message(from, TinyURL.get(:foo, hash))
  end
end
