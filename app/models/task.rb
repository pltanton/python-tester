class Task < ApplicationRecord
  has_many :tests, dependent: :destroy
  has_many :submissions, dependent: :destroy
end
