class User < ApplicationRecord
  validates_presence_of :login
  validates_presence_of :password

  def self.authenticate(login, password)
    user = find_by_login login
    user && user.password == password ? user : nil
  end
end
