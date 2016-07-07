module TasksHelper
  def submissions_of_user_for_task(user, task)
    Submission.where task: task, user: user
  end
end
