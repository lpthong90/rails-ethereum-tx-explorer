class TransactionsController < ApplicationController
  before_action :load_transactions, only: [:index]
  before_action :load_transaction, only: [:show]

  def index
  end

  def show
  end

  private

    def load_transactions
      @transactions = EventCache.fetch_list("transactions")
    end

    def load_transaction
      @transaction = begin
        data = web3.get_transaction_by_hash(params[:hash])
        Transaction.new.from_json(data.to_json)
      rescue
        nil
      end
    end
end
