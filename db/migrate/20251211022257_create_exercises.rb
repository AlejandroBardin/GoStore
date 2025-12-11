class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.string :title
      t.text :description
      t.text :initial_code
      t.text :solution_code
      t.integer :order
      t.references :course_module, null: false, foreign_key: true

      t.timestamps
    end
  end
end
