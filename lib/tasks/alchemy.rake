require 'alchemy/websocket/block'
require 'alchemy/websocket/transaction'

require './config/environment'

namespace :alchemy do
  desc "Starts alchemy websocket listener"
  task listen_ws: :environment do |task, args|
    block_ws, tx_ws = nil, nil

    block_thread = Thread.new do
      Alchemy::Websocket::Block.listen do |sub_type, event|
        handle_event(sub_type, event)
      end
    end
    tx_thread = Thread.new do
      Alchemy::Websocket::Transaction.listen do |sub_type, event|
        handle_event(sub_type, event)
      end
    end

    # Catch the interrupt signal (CTRL+C) to stop the thread gracefully
    Signal.trap("INT") do
      puts "Shutting down WebSocket listener..."
      
      Alchemy::Websocket::Block.stop
      Alchemy::Websocket::Transaction.stop

      # Wait for 2 threads to finish
      tx_thread.join
      block_thread.join

      exit
    end

    tx_thread.join
    block_thread.join
    puts "WebSocket listener has been shut down."
  end

  def handle_event(sub_type, event)
    puts "sub_type #{sub_type} #{event}"
    EventHandlerService.new(
      sub_type:,
      event:
    ).handle
  end

  desc "Starts broadcast alchemy event"
  task broadcast: :environment do |task, args|
    renderer = ApplicationController.renderer.new
    # event_data = EventCache.clear

    while true
      event_data = EventCache.all_lists(from: 0, to: 10)

      # Turbo::StreamsChannel.broadcast_to "home", content: turbo_stream
      ActionCable.server.broadcast(
        'home_channel',
        renderer.render(
          partial: 'home/update',
          locals: {
            blocks: event_data['blocks'][..5],
            transactions: event_data['transactions'][..5]
          }
        )
      )
      ActionCable.server.broadcast(
        'block_channel',
        renderer.render(
          partial: 'blocks/table/replace',
          locals: { blocks: event_data['blocks'] }
        )
      )
      ActionCable.server.broadcast(
        'transaction_channel',
        renderer.render(
          partial: 'transactions/table/replace',
          locals: { transactions: event_data['transactions'] }
        )
      )
      puts "[Broadcaster] Broadcasted to home channel"

      sleep 3.seconds
    end
  end
end
