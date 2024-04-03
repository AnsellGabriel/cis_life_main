import consumer from "./consumer"

consumer.subscriptions.create("DownloaderChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the downloader channel")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disconnected from the downloader channel")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received data from the downloader channel")
  }
});
