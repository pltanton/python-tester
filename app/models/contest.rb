class Contest < ApplicationRecord
  has_many :contest_tasks
  has_many :tasks, through: :contest_tasks
end
