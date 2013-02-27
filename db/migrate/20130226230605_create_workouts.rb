class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.text :exercises

      t.timestamps
    end
  end
end
