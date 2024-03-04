class Block < ApplicationModel
  attribute :baseFeePerGas, :hex_integer
  attribute :difficulty, :hex_integer
  attribute :extraData, :string
  attribute :gasLimit, :hex_integer
  attribute :gasUsed, :hex_integer
  attribute :hash, :string
  attribute :logsBloom, :string
  attribute :miner, :string
  attribute :mixHash, :string
  attribute :nonce, :hex_integer
  attribute :number, :hex_integer
  attribute :parentHash, :string
  attribute :receiptsRoot, :string
  attribute :sha3Uncles, :string
  attribute :size, :hex_integer
  attribute :stateRoot, :string
  attribute :timestamp, :hex_integer
  attribute :transactionsRoot, :string
  attribute :withdrawalsRoot, :string
  attribute :totalDifficulty, :hex_integer

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

  def eth_baseFeePerGas
    self.baseFeePerGas.to_d * 1e-18
  end

  def gwei_baseFeePerGas
    self.baseFeePerGas.to_d * 1e-9
  end

  def broadcast_to_channel
    ActionCable.server.broadcast('block_channel', { block: self })
  end

  private
    def current_timestamp
      Time.now.to_i
    end
end
