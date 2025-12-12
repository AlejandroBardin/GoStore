# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @purchased_avatars = Current.user.products.where(category: :avatar)
  end

  def update
    if params[:user][:avatar_product_id].present?
      update_avatar_from_product
    elsif Current.user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      @purchased_avatars = Current.user.products.where(category: :avatar)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end

  def update_avatar_from_product
    product = Product.find(params[:user][:avatar_product_id])

    unless Current.user.purchases.exists?(product: product)
      redirect_to profile_path, alert: "You don't own this avatar."
      return
    end

    attach_avatar(product)
    redirect_to profile_path, notice: "Avatar updated successfully!"
  rescue StandardError => e
    redirect_to profile_path, alert: "Failed to update avatar: #{e.message}"
  end

  def attach_avatar(product)
    if product.image_url.start_with?("http")
      downloaded_image = URI.parse(product.image_url).open
      filename = "#{product.name.parameterize}.svg"
      content_type = "image/svg+xml"
    else
      downloaded_image = File.open(Rails.root.join("app/assets/images", product.image_url))
      filename = product.image_url
      content_type = "image/png"
    end

    Current.user.avatar.attach(io: downloaded_image, filename: filename, content_type: content_type)
  end
end
