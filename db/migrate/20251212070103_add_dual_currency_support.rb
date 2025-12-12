class AddDualCurrencySupport < ActiveRecord::Migration[8.1]
  def change
    add_column :wallets, :gold_coins, :integer, default: 0, null: false
    add_column :products, :currency, :integer, default: 0, null: false
  end
end
