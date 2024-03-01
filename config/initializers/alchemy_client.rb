require 'alchemy/rpc_client'

Rails.application.configure do
  config.alchemy = Alchemy::RpcClient
end
