class EventHandlerService
  MINED_TRANSACTION_TYPE = "alchemy_minedTransactions"
  NEW_BLOCK_TYPE = "newHeads"

  def initialize(sub_type:, event:)
    @sub_type = sub_type
    @event = event

    puts "sub_type #{sub_type} event #{event}"
  end

  def handle
    case sub_type
    when EventHandlerService::MINED_TRANSACTION_TYPE
      handle_mined_transaction_event
    when EventHandlerService::NEW_BLOCK_TYPE
      handle_new_block_event
    end
  end

  private
    attr_reader :sub_type, :event

    def handle_mined_transaction_event
      # ActionCable.server.broadcast('transaction_channel', msg.data)
      transaction = Transaction.from_event(event)
      if transaction.valid?
        EventCache.add_transaction(transaction)
        puts "=> cached tx: #{transaction.hash}"
      else
        puts transaction.errors
      end
    end

    def handle_new_block_event
      block = Block.from_event(event)
      if block.valid?
        EventCache.add_block(block)
        puts "=> cached block: #{block.hash}"
      else
        puts block.errors
      end
    end
end
