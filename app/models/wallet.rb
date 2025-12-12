# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :gold_coins, numericality: { greater_than_or_equal_to: 0 }

  def deposit(amount, currency: :ruby)
    if currency == :gold
      update!(gold_coins: gold_coins + amount)
    else
      update!(balance: balance + amount)
    end
  end

  def withdraw(amount, currency: :ruby)
    return false if amount <= 0

    if currency == :gold
      return false if gold_coins < amount

      update!(gold_coins: gold_coins - amount)
    else
      return false if balance < amount

      update!(balance: balance - amount)
    end
  end
end
