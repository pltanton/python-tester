json.array!(@users) do |user|
  json.extract! user, :id, :login, :admin, :password
  json.url user_url(user, format: :json)
end
