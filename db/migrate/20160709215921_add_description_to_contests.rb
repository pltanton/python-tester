class AddDescriptionToContests < ActiveRecord::Migration[5.0]
  def change
    add_column :contests, :description, :text
  end
end
