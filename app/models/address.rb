class Address
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :address, :balance

  FORMAT_REGEX = /0x[a-fA-F0-9]{40}/

  validates :address, presence: true
  validates_format_of :address, with: FORMAT_REGEX

  def balance=(value)
    @balance = value.to_i(16) rescue 0
  end

  def eth_balance
    balance.to_d * 1e-18
  end

  def wei_balance
    balance
  end
end
