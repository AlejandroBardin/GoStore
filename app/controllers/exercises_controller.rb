# frozen_string_literal: true

class ExercisesController < ApplicationController
  def show
    @exercise = Exercise.find(params[:id])
  end
end
