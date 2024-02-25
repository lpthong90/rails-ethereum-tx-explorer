class ApplicationController < ActionController::Base
  def web3
    @web3 = Rails.application.config.alchemy
  end
end
