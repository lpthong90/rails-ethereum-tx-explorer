import consumer from "channels/consumer"

consumer.subscriptions.create("TransactionChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to TransactionChannel!");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disconnected to TransactionChannel!");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received from TransactionChannel:", data.message);
  }
});
