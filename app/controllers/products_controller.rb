# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:price)
  end

  def purchase
    product = Product.find(params[:id])

    begin
      PurchaseAvatarService.new(Current.user, product).call
      redirect_to products_path, notice: "¡Avatar comprado con éxito! 🎉"
    rescue PurchaseAvatarService::Error => e
      redirect_to products_path, alert: e.message
    end
  end
end
