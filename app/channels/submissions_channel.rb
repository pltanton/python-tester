class SubmissionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "submissions_#{current_user.id}"
  end

  def unsubscribed
    puts '-' * 1000
    
    # Any cleanup needed when channel is unsubscribed
  end
end
