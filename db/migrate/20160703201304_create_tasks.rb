class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title, nil: false
      t.text :body, nil: false
      t.text :format
    end
  end
end
