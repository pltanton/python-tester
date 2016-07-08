class Test < ApplicationRecord
  belongs_to :task
  has_many :submissions, foreign_key: :bad_test_id, dependent: :nullify
end
