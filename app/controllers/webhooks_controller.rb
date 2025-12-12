# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  allow_unauthenticated_access

  def mercadopago
    process_payment if params[:type] == "payment"
    head :ok
  rescue StandardError => e
    Rails.logger.error "MercadoPago Webhook Exception: #{e.message}"
    head :ok
  end

  private

  def process_payment
    payment_id = params[:data][:id]
    response = fetch_payment(payment_id)

    if response.success?
      handle_successful_payment_response(response)
    else
      Rails.logger.error "MercadoPago Webhook Error: Could not fetch payment #{payment_id}"
    end
  end

  def handle_successful_payment_response(response)
    payment_data = response.body
    process_approved_payment(payment_data) if payment_data["status"] == "approved"
  end

  def fetch_payment(payment_id)
    conn = Faraday.new(url: "https://api.mercadopago.com") do |f|
      f.request :json
      f.response :json
      f.adapter Faraday.default_adapter
      f.headers["Authorization"] = "Bearer #{Rails.application.credentials.mercadopago[:access_token]}"
    end
    conn.get("/v1/payments/#{payment_id}")
  end

  def process_approved_payment(payment_data)
    external_reference = payment_data["external_reference"]
    user_id = external_reference.split("-").first
    payment_id = payment_data["id"].to_s

    user = User.find_by(id: user_id)
    return unless user

    return if payment_processed?(payment_id)

    record_payment_and_credit_coins(user, payment_data, payment_id)
  end

  def payment_processed?(payment_id)
    if PaymentTransaction.exists?(external_id: payment_id, status: "approved")
      Rails.logger.info "Payment #{payment_id} already processed. Skipping."
      true
    else
      false
    end
  end

  def record_payment_and_credit_coins(user, payment_data, payment_id)
    ActiveRecord::Base.transaction do
      create_transaction(user, payment_data, payment_id)
      credit_gold_coins(user, payment_id)
    end
  end

  def create_transaction(user, payment_data, payment_id)
    PaymentTransaction.create!(
      external_id: payment_id,
      status: "approved",
      amount: payment_data["transaction_amount"],
      currency: payment_data["currency_id"],
      user: user
    )
  end

  def credit_gold_coins(user, payment_id)
    Rails.logger.info "Crediting 10 Gold Coins to User #{user.id} for Payment #{payment_id}"
    user.wallet.deposit(10, currency: :gold)
  end
end
