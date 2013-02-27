class WorkoutsController < ApplicationController
  def index
  end

  def show
    @workout = Workout.first
  end

  def update
    @workout = Workout.first
    @workout.add_set params[:reps]
    @workout.save
    redirect_to '/break'
  end
end
