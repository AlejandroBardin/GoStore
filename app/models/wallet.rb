# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def deposit(amount)
    update!(balance: balance + amount)
  end

  def withdraw(amount)
    return false if balance < amount

    update!(balance: balance - amount)
  end
end
