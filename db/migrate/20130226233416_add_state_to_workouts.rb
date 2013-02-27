class AddStateToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :state, :string
  end
end
