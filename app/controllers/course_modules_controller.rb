# frozen_string_literal: true

class CourseModulesController < ApplicationController
  allow_unauthenticated_access only: %i[index]
  def index
    @course_modules = CourseModule.includes(:exercises).order(:order)
  end
end
