class HomeController < ApplicationController
  before_action :load_data, only: [:index]

  def index
  end

  private
    def load_data
      @blocks = data['blocks']
      @transactions = data['transactions']
    end

    def data
      @data ||= EventCache.all_lists
    end
end
