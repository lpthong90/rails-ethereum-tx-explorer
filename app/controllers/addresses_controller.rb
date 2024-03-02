class AddressesController < ApplicationController
  before_action :load_address_balance, only: [:show]
  before_action :load_address, only: [:show]
  before_action :load_transactions, only: [:show]

  def show
    # TODO
  end

  private

    def load_address_balance
      @address_balance = web3.get_balance(params[:address])
    end

    def load_address
      @address = begin
        taddress = Address.new(
          address: params[:address]
        )
        taddress.balance = @address_balance
        taddress if taddress.validate
      end
    end

    def load_transactions
      @transactions = []
    end
end
