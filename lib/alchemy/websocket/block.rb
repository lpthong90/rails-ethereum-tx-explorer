module Alchemy
  module Websocket
    class Block
      class << self
        def listen(&block)
          @should_continue = true
          @sub_type = "newHeads"

          url = ENV['ALCHEMY_WEBSOCKET_URL']
          ws = WebSocket::Client::Simple.connect(url)
      
          ws.on :message do |msg|
            if block_given?
              event = JSON.parse(msg.data)
              puts "[WS newHeads] Received event: #{event}"
              yield ["newHeads", event]
            end
          end
      
          ws.on :open do
            subscribe_message = {
              jsonrpc: "2.0",
              id: 2,
              method: "eth_subscribe",
              params: [ "newHeads" ]
            }.to_json
            ws.send subscribe_message
          end
      
          ws.on :close do |e|
            puts "[WS newHeads] Connection has been closed"
          end
      
          ws.on :error do |e|
            puts "[WS newHeads] Error: #{e.message}"
          end
      
          while @should_continue
            sleep 1
            # This loop keeps running until @should_continue becomes false.
          end

          ws.close
          puts "WebSocket newHeads connection has been gracefully closed."
        end

        def stop
          @should_continue = false
        end
      end
    end
  end
end