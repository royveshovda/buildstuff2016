defmodule Logic.TwitterWorker do
  use GenServer

  require Logger

  @hashtag "#buildstuff_nerves_workshop"
  @user_handle "@RoyV33706219"

  ## Client API
  def send(message) do
    GenServer.cast(__MODULE__, {:send_tweet, message})
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Server API
  def init([]) do
    Process.send_after(self(), :starting, 500)
    {:ok, %{running: false}}
  end

  def handle_info(:starting, state) do
    case DateTime.utc_now.year do
      1970 ->
        Process.send_after(self(), :starting, 500)
        {:noreply, state}
      _ ->
        worker = self()
        pid = start_twitter_stream(worker)
        {:noreply, %{pid: pid, running: true}}
    end
  end

  defp start_twitter_stream(pid_to_send_result) do
    pid = spawn(fn ->
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

  def handle_cast({:send_tweet, message}, state) do
    case state.running do
      true ->
        ExTwitter.update(message)
        Logger.debug "Tweeted: #{message}"
      false ->
        Logger.warn "ExTwitter not running yet"
    end
    {:noreply, state}
  end
end
