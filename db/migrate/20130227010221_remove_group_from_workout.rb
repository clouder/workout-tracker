class RemoveGroupFromWorkout < ActiveRecord::Migration
  def up
    remove_column :workouts, :group
  end

  def down
    add_column :workouts, :group
  end
end
