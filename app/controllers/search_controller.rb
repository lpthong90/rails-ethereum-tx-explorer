class SearchController < ApplicationController
  before_action :check_hash_format, only: [:index]
  before_action :check_address_format, only: [:index]
  before_action :check_number_format, only: [:index]

  def index
  end

  private
    def check_hash_format
      if !!matched_hash_result && matched_hash_result[0].size == 66
        redirect_to show_tx_path(hash: params[:q])
      end
    end

    def check_address_format
      if !!matched_address_result && matched_address_result[0].size == 42
        redirect_to show_address_path(address: params[:q])
      end
    end

    def check_number_format
      if !!matched_number_result && matched_number_result[0] != "0"
        redirect_to show_block_path(block_id: matched_number_result[0])
      end
    end

    def matched_hash_result
      @matched_hash_result ||= params[:q].match(Transaction::HASH_FORMAT_REGEX)
    end

    def matched_address_result
      @check_address_result ||= params[:q].match(Address::FORMAT_REGEX)
    end

    def matched_number_result
      @check_number_result ||= params[:q].match(Block::NUMBER_FORMAT_REGEX)
    end
end
