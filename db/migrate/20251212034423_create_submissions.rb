class CreateSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.text :code
      t.integer :status

      t.timestamps
    end
    add_index :submissions, [:user_id, :exercise_id], unique: true
  end
end
