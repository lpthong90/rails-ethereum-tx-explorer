class Address < ApplicationModel
  attribute :address, :string
  attribute :balance, :hex_integer

  FORMAT_REGEX = /0x[a-fA-F0-9]{40}/

  validates :address, presence: true
  validates_format_of :address, with: FORMAT_REGEX

  def eth_balance
    balance.to_d * 1e-18
  end

  def wei_balance
    balance
  end
end
