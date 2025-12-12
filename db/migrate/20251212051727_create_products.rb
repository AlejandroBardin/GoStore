class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price, default: 0
      t.integer :category
      t.string :image_url

      t.timestamps
    end
  end
end
