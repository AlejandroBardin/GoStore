# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :products, through: :purchases
  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create :create_default_wallet

  private

  def create_default_wallet
    create_wallet(balance: 1000)
  end
end
