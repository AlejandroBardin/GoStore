class CourseModule < ApplicationRecord
  has_many :exercises, dependent: :destroy
end
