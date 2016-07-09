class ContestTask < ApplicationRecord
  belongs_to :contest, dependent: :destroy
  belongs_to :task, dependent: :destroy

  validates_uniqueness_of :contest, scope: :task
end
