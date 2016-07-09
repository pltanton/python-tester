class CreateContestTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :contest_tasks do |t|
      t.belongs_to :contest, foreign_key: true, nil: false
      t.belongs_to :task, foreign_key: true, nil: false
    end
    add_index :contest_tasks, %i(contest_id task_id), unique: true
  end
end
