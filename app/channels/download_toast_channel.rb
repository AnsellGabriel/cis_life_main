class DownloadToastChannel < ApplicationCable::Channel
  def subscribed
    stream_from "downloader_toast_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
