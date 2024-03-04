class Block < ApplicationModel
  attribute :base_fee_per_gas, :hex_integer
  attribute :difficulty, :hex_integer
  attribute :extra_data, :string
  attribute :gas_limit, :hex_integer
  attribute :gas_used, :hex_integer
  attribute :hash, :string
  attribute :logs_bloom, :string
  attribute :miner, :string
  attribute :mix_hash, :string
  attribute :nonce, :hex_integer
  attribute :number, :hex_integer
  attribute :parent_hash, :string
  attribute :receipts_root, :string
  attribute :sha3_uncles, :string
  attribute :size, :hex_integer
  attribute :state_root, :string
  attribute :timestamp, :hex_integer
  attribute :transactions_root, :string
  attribute :withdrawals_root, :string
  attribute :total_difficulty, :hex_integer

  attr_accessor :withdrawals, :transactions, :uncles

  NUMBER_FORMAT_REGEX = /-?\d+/

  validates :hash, presence: true

  def transactions=(value)
    @transactions = value ? value : []
  end

  def datetime
    Time.at(self.timestamp)
  end

  def seconds_ago
    current_timestamp - self.timestamp
  end

  def eth_base_fee_per_gas
    self.base_fee_per_gas.to_d * 1e-18
  end

  def gwei_base_fee_per_gas
    self.base_fee_per_gas.to_d * 1e-9
  end

  def broadcast_to_channel
    ActionCable.server.broadcast('block_channel', { block: self })
  end

  private
    def current_timestamp
      Time.now.to_i
    end
end
