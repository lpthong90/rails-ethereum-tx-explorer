class BlockChannel < ApplicationCable::Channel
  def subscribed
    stream_from "block_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
