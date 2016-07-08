class AddBadTestAndOutToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :bad_test_id, :integer
    add_column :submissions, :bad_out, :string
    add_foreign_key :submissions, :tests, column: :bad_test_id
  end
end
