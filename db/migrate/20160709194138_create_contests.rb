class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.string :name, nil: false
      t.integer :position, nil: false
      t.boolean :active, nil: false, default: true
    end
    add_index :contests, :name, unique: true
    add_index :contests, :position, unique: true
  end
end
