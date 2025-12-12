# frozen_string_literal: true

class Exercise < ApplicationRecord
  belongs_to :course_module
  has_many :submissions, dependent: :destroy

  validates :title, presence: true
end
