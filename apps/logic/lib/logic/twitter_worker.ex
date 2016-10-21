defmodule Logic.TwitterWorker do
  use GenServer

  @hashtag "#buildstuff_nerves_workshop"
  @user_handle "@RoyV33706219"

  def send(message) do
    ExTwitter.update(message)
    IO.puts "Tweeted: #{message}"
    :ok
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([]) do
    worker = self()
    pid = spawn(fn ->
      Process.sleep(15000)
      IO.puts "Listening to Twitter"
      stream = ExTwitter.stream_filter(track: @hashtag)
      for tweet <- stream do
        GenServer.cast(worker, {:tweet_update, tweet})
      end
    end)
    {:ok, {%{pid: pid}}}
  end

  def handle_cast({:tweet_update, tweet}, state) do
    message = String.replace(tweet.text, @hashtag, "")
    Logic.CounterCoordinator.send_update(message)
    {:noreply, state}
  end
end
