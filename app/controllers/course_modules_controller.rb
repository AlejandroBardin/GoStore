class CourseModulesController < ApplicationController
  def index
    @course_modules = CourseModule.includes(:exercises).order(:order)
  end
end
