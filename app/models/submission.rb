# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  enum :status, { pending: 0, failed: 1, passed: 2 }, default: :pending

  validates :code, presence: true
  validates :status, presence: true
end
