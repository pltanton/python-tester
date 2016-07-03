json.array!(@submissions) do |submission|
  json.extract! submission, :id, :task_id, :user_id, :status, :timestamp, :solution
  json.url submission_url(submission, format: :json)
end
