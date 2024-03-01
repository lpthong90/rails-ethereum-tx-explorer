class BlocksController < ApplicationController
  before_action :load_blocks, only: [:index]
  before_action :load_block, only: [:show]

  def index
  end

  def show
  end

  private
    def load_blocks
      @blocks = EventCache.fetch_list("blocks")
    end

    def load_block
      @block = begin
        data = web3.get_block_by_hash(params[:hash])
        Block.new.from_json(data.to_json)
      rescue
        nil
      end
    end
end
