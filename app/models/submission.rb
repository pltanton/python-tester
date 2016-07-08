class Submission < ApplicationRecord
  belongs_to :task
  belongs_to :user

  after_commit { SubmissionsBroadcastJob.perform_later self }

  def self.find_for_user_and_task(user, task)
    where(task: task, user: user).order id: :desc
  end
end
