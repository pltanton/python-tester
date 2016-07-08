class SubmissionsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(submission)
    ActionCable.server.broadcast "submissions_#{submission.user_id}",
                                 render_submission(submission)
  end

  private

  def render_submission(submission)
    ApplicationController.renderer.render partial: 'submissions/tr',
                                          locals: { submission: submission }
  end
end
