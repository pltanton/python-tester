class CreateTests < ActiveRecord::Migration[5.0]
  def change
    create_table :tests do |t|
      t.belongs_to :task, foreign_key: true, nil: false
      t.text :in, nil: false
      t.text :out, nil: false
    end
  end
end
