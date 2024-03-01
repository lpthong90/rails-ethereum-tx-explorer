module Alchemy
  module Websocket
    class Transaction
      class << self
        def listen(&block)
          @should_continue = true
          @sub_type = "alchemy_minedTransactions"

          url = ENV['ALCHEMY_WEBSOCKET_URL']
          ws = WebSocket::Client::Simple.connect(url)
      
          ws.on :message do |msg|
            if block_given?
              event = JSON.parse(msg.data)
              puts "[WS alchemy_minedTransactions] Received event: #{event}"
              yield ["alchemy_minedTransactions", event]
            end
          end
      
          ws.on :open do
            subscribe_message = {
              jsonrpc: "2.0",
              id: 2,
              method: "eth_subscribe",
              params: [ "alchemy_minedTransactions" ]
            }.to_json
            ws.send subscribe_message
          end
      
          ws.on :close do |e|
            puts "[WS alchemy_minedTransactions] Connection has been closed"
          end
      
          ws.on :error do |e|
            puts "[WS alchemy_minedTransactions] Error: #{e.message}"
          end
      
          while @should_continue
            sleep 1
            # This loop keeps running until @should_continue becomes false.
          end

          ws.close
          puts "WebSocket alchemy_minedTransactions connection has been gracefully closed."
        end

        def stop
          @should_continue = false
        end
      end
    end
  end
end