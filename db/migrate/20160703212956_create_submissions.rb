class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.belongs_to :task, foreign_key: true, nil: false
      t.belongs_to :user, foreign_key: true, nil: false
      t.string :status, nil: false, default: 'CH'
      t.datetime :timestamp, nil: false
      t.binary :solution, nil: false
    end
  end
end
