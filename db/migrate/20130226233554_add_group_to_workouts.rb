class AddGroupToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :group, :integer
  end
end
