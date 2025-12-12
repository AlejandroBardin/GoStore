# frozen_string_literal: true

class PaymentTransaction < ApplicationRecord
  belongs_to :user
end
