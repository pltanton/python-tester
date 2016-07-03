class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login, nil: false
      t.string :password, nil: false
      t.boolean :admin, nil: false, default: false
    end
    add_index :users, :login, unique: true
  end
end
