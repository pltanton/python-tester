json.array!(@contests) do |contest|
  json.extract! contest, :id, :name, :position, :active
  json.url contest_url(contest, format: :json)
end
