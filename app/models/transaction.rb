class Transaction < ApplicationModel
  attribute :hash, :string
  attribute :from, :string
  attribute :to, :string
  attribute :blockHash, :string
  attribute :blockNumber, :hex_integer
  attribute :gas, :hex_integer
  attribute :gasPrice, :hex_integer
  attribute :input, :hex_integer
  attribute :nonce, :hex_integer
  attribute :r, :string
  attribute :s, :string
  attribute :transactionIndex, :hex_integer
  attribute :type, :hex_integer
  attribute :v, :hex_integer
  attribute :value, :hex_integer
  attribute :chainId, :hex_integer
  attribute :maxFeePerGas, :hex_integer
  attribute :maxPriorityFeePerGas, :hex_integer
  attribute :yParity, :hex_integer

  attr_accessor :accessList

  HASH_FORMAT_REGEX = /0x[a-fA-F0-9]{64}/

  validates_format_of :hash, with: HASH_FORMAT_REGEX

  def eth_value
    self.value.to_d * 1e-18
  end

  def wei_value
    self.value
  end

  def fee
    self.gas * self.gasPrice
  end

  def eth_fee
    fee.to_d * 1e-18
  end

  def broadcast_to_channel
    ActionCable.server.broadcast('transaction_channel', { transaction: self })
  end

  def broadcast_to_stream
    broadcast_append_to "transactions", target: "transactions", partial: "transactions/transaction", locals: { transaction: self }
  end
end
