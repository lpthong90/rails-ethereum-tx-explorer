class Transaction
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  include Turbo::Broadcastable

  attr_accessor :hash, :from, :to, :blockHash, :blockNumber, :gas, :gasPrice,
                :input, :nonce, :r, :s, :transactionIndex, :type, :v, :value,
                :accessList, :chainId, :maxFeePerGas, :maxPriorityFeePerGas, :yParity

  def attributes
    {hash: hash, from: from, to: to}
  end

  validates :hash, :from, :to, presence: true
  # :blockHash, :blockNumber, :hash, :from, :gas, :gasPrice, :input, :nonce, 
  #           :r, :s, :to, :transactionIndex, :type, :v, :value, presence: true

  validates_format_of :hash, with: /0x[a-fA-F0-9]{64}/
  # validates_format_of :from, :to, with: /0x[a-fA-F0-9]{40}/
  # validates_format_of :blockHash, with: /0x[a-fA-F0-9]{64}/

  def self.from_event(event)
    transaction_data = event&.dig("params", "result", "transaction")
    return unless transaction_data
    Transaction.new(**transaction_data)
  end

  def broadcast_to_channel
    ActionCable.server.broadcast('transaction_channel', { transaction: self })
  end

  def broadcast_to_stream
    broadcast_append_to "transactions", target: "transactions", partial: "transactions/transaction", locals: { transaction: self }
  end
end
