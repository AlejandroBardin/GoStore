# frozen_string_literal: true

class CourseModule < ApplicationRecord
  has_many :exercises, dependent: :destroy
end
