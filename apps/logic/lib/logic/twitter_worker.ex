defmodule Logic.TwitterWorker do
  use GenServer

  @hashtag "#buildstuff_nerves_workshop"
  @user_handle "@RoyV33706219"

  def send(message) do
    ExTwitter.update(message)
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    worker = self()
    pid = spawn(fn ->
      stream = ExTwitter.stream_filter(track: @hashtag)
      for tweet <- stream do
        GenServer.cast(worker, {:tweet_update, tweet})
      end
    end)
    {:ok, {%{pid: pid}}}
  end

  def handle_cast({:tweet_update, tweet}, state) do
    IO.puts tweet.text
    {:noreply, state}
  end
end
