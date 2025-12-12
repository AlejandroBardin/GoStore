# frozen_string_literal: true

class CourseModulesController < ApplicationController
  allow_unauthenticated_access only: %i[index]
  def index
    @course_modules = CourseModule.includes(:exercises).order(:order)
    @completed_exercise_ids = if Current.user
                                Current.user.submissions.passed.pluck(:exercise_id)
                              else
                                []
                              end
  end
end
