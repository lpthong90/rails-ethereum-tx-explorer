# require 'faye/websocket'
# require 'eventmachine'
# require 'json'


# # Replace 'your_alchemy_websocket_url' with your actual Alchemy WebSocket URL
# ws_url = '...'


# # Method to connect to the WebSocket
# def connect_to_websocket(ws_url)
#   ws = Faye::WebSocket::Client.new(ws_url)

#   ws.on :open do |event|
#     puts "Connected to #{ws_url}"

#     # Example subscription message - replace this with actual subscription JSON for Alchemy
#     subscribe_message = {
#       jsonrpc: "2.0",
#       id: 2,
#       method: "eth_subscribe",
#       params: [
#         "alchemy_minedTransactions",
#         { "addresses": 
#           [
#             {
#               "to": "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984"
#             }
#           ]
#         }
#       ]
#     }.to_json

#     ws.send(subscribe_message)
#   end

#   ws.on :message do |event|
#     puts "Received message: #{event.data}"
#   end

#   ws.on :close do |event|
#     puts "Connection closed, attempting to reconnect..."
#     # Attempt to reconnect after 5 seconds
#     EventMachine.add_timer(5) do
#       connect_to_websocket(ws_url)
#     end
#   end

#   ws.on :error do |event|
#     puts "Error: #{event.message}"
#     # You may also want to attempt reconnection in case of errors
#     # depending on the nature of the error and your use case
#   end
# end

# EventMachine.run do
#   connect_to_websocket(ws_url)
# end
