# frozen_string_literal: true

class PurchaseAvatarService
  class Error < StandardError; end

  def initialize(user, product)
    @user = user
    @product = product
  end

  def call
    validate_purchase!

    ActiveRecord::Base.transaction do
      perform_transaction
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Error, e.message
  end

  private

  def validate_purchase!
    raise Error, "Product is not an avatar" unless @product.avatar?
    raise Error, "User already owns this avatar" if @user.purchases.exists?(product: @product)
  end

  def perform_transaction
    wallet = @user.wallet || @user.create_wallet
    wallet.lock! # Pessimistic locking to prevent race conditions

    raise Error, "Insufficient funds" unless wallet.withdraw(@product.price, currency: @product.currency.to_sym)

    Purchase.create!(user: @user, product: @product)
  end
end
