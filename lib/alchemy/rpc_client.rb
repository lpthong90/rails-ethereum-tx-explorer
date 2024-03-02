module Alchemy
  class RpcClient
    include HTTParty
    base_uri ENV["ALCHEMY_URL"]

    def self.get_balance(address)
      body_data = build_data('eth_getBalance', [address, 'latest'])
      post('/', body: body_data.to_json)['result']
    rescue StandardError
      nil
    end

    def self.get_transactions(options); end

    def self.get_transaction_by_hash(hash)
      body_data = build_data('eth_getTransactionByHash', [hash])
      post('/', body: body_data.to_json)['result']
    rescue StandardError
      nil
    end

    def self.get_block_by_hash(hash, include_txs: false)
      body_data = build_data('eth_getBlockByHash', [hash, include_txs])
      post('/', body: body_data.to_json)['result']
    rescue StandardError
      nil
    end

    def self.get_block_by_number(number, include_txs: false)
      body_data = build_data('eth_getBlockByNumber', ["0x#{number.to_s(16)}", include_txs])
      post('/', body: body_data.to_json)['result']
    # rescue StandardError
    #   nil
    end

    private
      def self.build_data(method, params)
        {
          jsonrpc: '2.0',
          id: 2,
          method:,
          params:
        }
      end
  end
end
