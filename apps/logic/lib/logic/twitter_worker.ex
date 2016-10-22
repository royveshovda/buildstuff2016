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
    Process.send_after(self(), :starting, 500)
    {:ok, %{}}
  end

  def handle_info(:starting, state) do
    case DateTime.utc_now.year do
      1970 ->
        Process.send_after(self(), :starting, 500)
        {:noreply, state}
      _ ->
        worker = self()
        pid = start_twitter_stream(worker)
        {:noreply, %{pid: pid}}
    end
  end

  defp start_twitter_stream(pid_to_send_result) do
    pid = spawn(fn ->
      Process.sleep(15000)
      IO.puts "Listening to Twitter"
      stream = ExTwitter.stream_filter(track: @hashtag)
      for tweet <- stream do
        GenServer.cast(pid_to_send_result, {:tweet_update, tweet})
      end
    end)
    pid
  end



  def handle_cast({:tweet_update, tweet}, state) do
    message = String.replace(tweet.text, @hashtag, "")
    Logic.CounterCoordinator.send_update(message)
    {:noreply, state}
  end
end
