json.array!(@tests) do |test|
  json.extract! test, :id, :task_id, :in, :out
  json.url test_url(test, format: :json)
end
