class EventCache
  TRANSACTION_QUEUE_LIMIT = ENV.fetch("TRANSACTION_QUEUE_LIMIT", '20').to_i
  BLOCK_QUEUE_LIMIT = ENV.fetch("BLOCK_QUEUE_LIMIT", '20').to_i

  class << self
    def add_transaction(transaction)
      cache.eval(add_item_script, keys: ['transactions'], argv: [transaction.to_json, EventCache::TRANSACTION_QUEUE_LIMIT])
      cache.set("transactions:#{transaction.hash}", transaction.to_json, ex: 5.minutes)
    end

    def add_block(block)
      cache.eval(add_item_script, keys: ['blocks'], argv: [block.to_json, EventCache::BLOCK_QUEUE_LIMIT])
      cache.set("blocks:#{block.hash}", block.to_json, ex: 5.minutes)
    end

    def fetch_transactions(from: 0, to: 5)
      data = fetch_list("transactions", from:, to:)
      data.map { |d| Transaction.new(JSON.parse(d)) }
    end

    def fetch_blocks(from: 0, to: 5)
      data = fetch_list("blocks", from:, to:)
      data.map { |d| Block.new(JSON.parse(d)) }
    end

    def fetch_list(list, from:, to:)
      cache.lrange(list, from, to)
    end

    def all_lists(from: 0, to: 5)
      results = {}
      mutex = Mutex.new

      [
        ["transactions", Transaction],
        ["blocks", Block],
      ].map do |list_name, model|
        Thread.new do
          list_data = fetch_list(list_name, from:, to:)
          mutex.synchronize do
            results[list_name] = list_data.map do |data|
              model.new(JSON.parse(data))
            end
          end
        end
      end.each(&:join)

      results
    end

    def clear
      cache.ltrim("blocks", 1, 0)
      cache.ltrim("transactions", 1, 0)
    end

    private

      def print_script
        "return ARGV[1]"
      end

      def add_item_script
        <<-LUA
          redis.call('LPUSH', KEYS[1], ARGV[1]);
          redis.call('LTRIM', KEYS[1], 0, tonumber(ARGV[2]));
        LUA
      end

      def cache
        Rails.configuration.redis_cache
      end
  end
end
