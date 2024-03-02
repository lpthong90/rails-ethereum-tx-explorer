class Block
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  include Turbo::Broadcastable

  include StringConcern

  attr_accessor :baseFeePerGas, :difficulty, :extraData, :gasLimit, :gasUsed, :hash,
                :logsBloom, :miner, :mixHash, :nonce, :number, :parentHash, :receiptsRoot,
                :sha3Uncles, :size, :stateRoot, :timestamp, :transactionsRoot, :withdrawals, 
                :withdrawalsRoot, :transactions, :totalDifficulty, :uncles
  
  validates :hash, presence: true

  def attributes
    {
      hash: hash,
      number: number,
      timestamp: timestamp,
      miner: miner,
      transactions: transactions,
      withdrawals: withdrawals,
      baseFeePerGas: baseFeePerGas,
      totalDifficulty: totalDifficulty,
      size: size
    }
  end

  def totalDifficulty=(value)
    @totalDifficulty = value.class == Integer ? value : value.to_i(16) rescue nil
  end

  def size=(value)
    @size = value.class == Integer ? value : value.to_i(16)
  end

  def number=(value)
    @number = value.class == Integer ? value : value.to_i(16)
  end

  def baseFeePerGas=(value)
    @baseFeePerGas = value.class == Integer ? value : value.to_i(16)
  end

  def datetime
    Time.at(self.timestamp)
  end

  def timestamp=(value)
    @timestamp = value.class == Integer ? value : value.to_i(16)
  end

  def transactions=(value)
    @transactions = value ? value : []
  end

  def broadcast_to_channel
    ActionCable.server.broadcast('block_channel', { block: self })
  end

  def self.from_event(event)
    from_json(event&.dig("params", "result"))
  end

  def self.from_json(data)
    return unless data
    Block.new(**data)
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

  private
    def current_timestamp
      Time.now.to_i
    end
end
