# frozen_string_literal: true

class CheckoutController < ApplicationController
  def create
    client = MercadoPagoClient.new
    preference_data = build_preference_data
    response = client.create_preference(preference_data)

    if response.success?
      redirect_to response.body["init_point"], allow_other_host: true
    else
      handle_error(response)
    end
  rescue StandardError => e
    handle_exception(e)
  end

  private

  def build_preference_data
    {
      items: preference_items,
      payer: { email: Current.user.email_address },
      back_urls: preference_back_urls,
      auto_return: "approved",
      external_reference: "#{Current.user.id}-#{Time.current.to_i}",
      notification_url: "#{Settings.app_url}/webhooks/mercadopago"
    }
  end

  def preference_items
    [
      {
        id: "gold_coins_10",
        title: "Pack 10 Gold Coins",
        quantity: 1,
        currency_id: "ARS",
        unit_price: 50.0
      }
    ]
  end

  def preference_back_urls
    {
      success: "#{Settings.app_url}/products",
      failure: "#{Settings.app_url}/products",
      pending: "#{Settings.app_url}/products"
    }
  end

  def handle_error(response)
    Rails.logger.error "MercadoPago Error: #{response.status} - #{response.body}"
    redirect_to products_path, alert: "Error creando el pago: #{response.body}"
  end

  def handle_exception(exception)
    Rails.logger.error "Checkout Exception: #{exception.message}"
    redirect_to products_path, alert: "Error de conexión: #{exception.message}"
  end

  class MercadoPagoClient
    def connection
      @connection ||= Faraday.new(url: "https://api.mercadopago.com") do |f|
        f.request :json
        f.response :json
        f.adapter Faraday.default_adapter
        f.headers["Authorization"] = "Bearer #{Rails.application.credentials.mercadopago[:access_token]}"
      end
    end

    def create_preference(data)
      connection.post("/checkout/preferences", data)
    end
  end
end
