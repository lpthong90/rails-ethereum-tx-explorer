class BlocksController < ApplicationController
  before_action :load_blocks, only: [:index]
  before_action :load_block, only: [:show]
  before_action :load_transactions, only: [:show]

  def index
  end

  def show
  end

  private
    def load_blocks
      @blocks = EventCache.fetch_blocks(from: 0, to: 10)
    end

    def load_block
      @block = begin
        data = if params[:block_id].size == 66  # size of block's hash
          web3.get_block_by_hash(params[:block_id], include_txs: true)
        else 
          web3.get_block_by_number(params[:block_id].to_i, include_txs: true)
        end
        Block.new(data)
      rescue
        nil
      end
    end

    def load_transactions
      @transactions = @block.transactions.map { Transaction.new(_1) }
    rescue
      @transactions = []
    end
end
