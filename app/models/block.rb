class Block
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  include Turbo::Broadcastable

  attr_accessor :baseFeePerGas, :difficulty, :extraData, :gasLimit, :gasUsed, :hash,
                :logsBloom, :miner, :mixHash, :nonce, :number, :parentHash, :receiptsRoot,
                :sha3Uncles, :size, :stateRoot, :timestamp, :transactionsRoot, :withdrawals, 
                :withdrawalsRoot, :transactions, :totalDifficulty, :uncles
  
  validates :hash, presence: true

  def attributes
    {hash: hash, number: number}
  end

  def broadcast_to_channel
    ActionCable.server.broadcast('block_channel', { transaction: self })
  end

  def self.from_event(event)
    block_data = event&.dig("params", "result")
    return unless block_data
    Block.new(**block_data)
  end
end
