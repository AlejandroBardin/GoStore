# frozen_string_literal: true

class PurchaseAvatarService
  class Error < StandardError; end

  def initialize(user, product)
    @user = user
    @product = product
  end

  def call
    raise Error, "Product is not an avatar" unless @product.avatar?
    raise Error, "User already owns this avatar" if @user.purchases.exists?(product: @product)

    ActiveRecord::Base.transaction do
      wallet = @user.wallet || @user.create_wallet

      raise Error, "Insufficient funds" unless wallet.withdraw(@product.price)

      Purchase.create!(user: @user, product: @product)
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Error, e.message
  end
end
