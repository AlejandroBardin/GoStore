class CreatePaymentTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_transactions do |t|
      t.string :external_id
      t.string :status
      t.decimal :amount
      t.string :currency
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :payment_transactions, :external_id
  end
end
