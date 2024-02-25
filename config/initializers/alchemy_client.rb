require 'web3/alchemy'

Rails.application.configure do
  config.alchemy = Web3::Alchemy
end
