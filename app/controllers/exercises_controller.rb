# frozen_string_literal: true

class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[show check_solution]

  def show; end

  def check_solution
    code = params[:code]
    Rails.logger.info "Received solution for Exercise #{@exercise.id}:"
    Rails.logger.info code

    render json: { status: "received", message: "Code received successfully!" }
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end
end
