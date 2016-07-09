module SubmissionsHelper
  def status_for_user_task(user, task)
    submissions = Submission.where user: user, task: task


    if !submissions.any?
      { status: '-' }
    elsif submissions.where(status: 'OK').any?
      { status: 'OK' }
    else
      last_submission = submissions.order(id: :desc).take
      { status: last_submission.status, bad_submission: last_submission }
    end
  end
end
