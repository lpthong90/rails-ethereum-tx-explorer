module Web3
  class Alchemy
    include HTTParty
    base_uri 'https://eth-mainnet.g.alchemy.com/v2/...'

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

    # private

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
# 0x35819ca57c6625f39f7183f88688f648824d6cbfc69b6d9c9ef021b0b5621da3'
