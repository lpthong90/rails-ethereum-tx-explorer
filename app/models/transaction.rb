class Transaction
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  include Turbo::Broadcastable

  attr_accessor :hash, :from, :to, :blockHash, :blockNumber, :gas, :gasPrice,
                :input, :nonce, :r, :s, :transactionIndex, :type, :v, :value,
                :accessList, :chainId, :maxFeePerGas, :maxPriorityFeePerGas, :yParity

  HASH_FORMAT_REGEX = /0x[a-fA-F0-9]{64}/

  def attributes
    {hash: hash, from: from, to: to, value: value, blockNumber: blockNumber, gas: gas, gasPrice: gasPrice}
    # instance_values
  end

  validates :hash, :from, :to, presence: true
  # :blockHash, :blockNumber, :hash, :from, :gas, :gasPrice, :input, :nonce, 
  #           :r, :s, :to, :transactionIndex, :type, :v, :value, presence: true

  validates_format_of :hash, with: HASH_FORMAT_REGEX
  # validates_format_of :from, :to, with: /0x[a-fA-F0-9]{40}/
  # validates_format_of :blockHash, with: /0x[a-fA-F0-9]{64}/

  def value=(new_value)
    @value = new_value.class == Integer ? new_value : new_value.to_i(16)
  end

  def gas=(new_value)
    @gas = new_value.class == Integer ? new_value : new_value.to_i(16)
  end

  def gasPrice=(new_value)
    @gasPrice = new_value.class == Integer ? new_value : new_value.to_i(16)
  end

  def blockNumber=(value)
    @blockNumber = value.class == Integer ? value : value.to_i(16)
  end

  def eth_value
    self.value.to_d * 1e-18
  end

  def wei_value
    self.value
  end

  def self.from_event(event)
    from_json(event&.dig("params", "result", "transaction"))
  end

  def self.from_json(data)
    return unless data
    Transaction.new(**data)
  end

  def broadcast_to_channel
    ActionCable.server.broadcast('transaction_channel', { transaction: self })
  end

  def broadcast_to_stream
    broadcast_append_to "transactions", target: "transactions", partial: "transactions/transaction", locals: { transaction: self }
  end

  def seconds_ago
    current_timestamp - self.timestamp
  end

  def fee
    self.gas * self.gasPrice
  end

  def eth_fee
    fee.to_d * 1e-18
  end

  private
    def current_timestamp
      Time.now.to_i
    end
end
