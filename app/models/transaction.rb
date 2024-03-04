class Transaction < ApplicationModel
  attribute :hash, :string
  attribute :from, :string
  attribute :to, :string
  attribute :block_hash, :string
  attribute :block_number, :hex_integer
  attribute :gas, :hex_integer
  attribute :gas_price, :hex_integer
  attribute :input, :hex_integer
  attribute :nonce, :hex_integer
  attribute :r, :string
  attribute :s, :string
  attribute :transaction_index, :hex_integer
  attribute :type, :hex_integer
  attribute :v, :hex_integer
  attribute :value, :hex_integer
  attribute :chain_id, :hex_integer
  attribute :max_fee_per_gas, :hex_integer
  attribute :max_priority_fee_per_gas, :hex_integer
  attribute :y_parity, :hex_integer

  attr_accessor :access_list

  HASH_FORMAT_REGEX = /0x[a-fA-F0-9]{64}/

  validates_format_of :hash, with: HASH_FORMAT_REGEX

  def eth_value
    self.value.to_d * 1e-18
  end

  def wei_value
    self.value
  end

  def fee
    self.gas * self.gas_price
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
