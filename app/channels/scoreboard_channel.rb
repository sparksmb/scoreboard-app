class ScoreboardChannel < ApplicationCable::Channel
  def subscribed
    organization_id = params[:organization_id]
    stream_from "scoreboard_#{organization_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
