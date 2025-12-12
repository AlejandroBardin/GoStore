# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :purchases, dependent: :destroy
  has_many :users, through: :purchases

  enum :category, { avatar: 0, theme: 1 }
  enum :currency, { ruby: 0, gold: 1 }, default: :ruby

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
