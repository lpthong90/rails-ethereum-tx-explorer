class Transaction
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :hash, :from, :to, :blockHash, :blockNumber, :gas, :gasPrice,
                :input, :nonce, :r, :s, :transactionIndex, :type, :v, :value,
                :accessList, :chainId, :maxFeePerGas, :maxPriorityFeePerGas

  validates :hash, :from, :to, presence: true
  # :blockHash, :blockNumber, :hash, :from, :gas, :gasPrice, :input, :nonce, 
  #           :r, :s, :to, :transactionIndex, :type, :v, :value, presence: true

  validates_format_of :hash, with: /0x[a-fA-F0-9]{64}/
  validates_format_of :from, :to, with: /0x[a-fA-F0-9]{44}/
  # validates_format_of :blockHash, with: /0x[a-fA-F0-9]{64}/
end
