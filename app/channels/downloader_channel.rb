class DownloaderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "downloader"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
