require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  def setup
    @workout = workouts(:first)
  end

  def teardown
    @workout = nil
  end

  test 'fresh workout starts with squat' do
    assert_equal 'squats', @workout.exercise
  end

  test '#exercises should return a hash' do
    assert_kind_of Hash, @workout.exercises
  end

  test '#total_sets returns number of completed sets' do
    assert_equal 0, @workout.total_sets
    @workout.exercises[:squats][:reps] = '55555'
    assert_equal 5, @workout.total_sets
  end

  test 'after 5 sets of squats move to benchpress' do
    @workout.exercises[:squats][:reps] = '55555'
    @workout.complete_set
    assert_equal 'benchpress', @workout.exercise
  end

  test 'after 3 sets of squats do more squats' do
    @workout.exercises[:squats][:reps] = '555'
    @workout.complete_set
    assert_equal 'squats', @workout.exercise
  end

  test '#total_reps returns total reps of all sets' do
    @workout.exercises[:squats][:reps] = '54321'
    assert_equal 15, @workout.total_reps
    @workout.exercises[:squats][:reps] = '55555'
    assert_equal 25, @workout.total_reps
  end

  test 'after 5 sets if #total_reps is below 25 #increment_failure' do
    @workout.exercises[:squats][:failures] = 1
    @workout.exercises[:squats][:reps] = '54321'
    assert_difference '@workout.exercises[:squats][:failures]', +1 do
      @workout.complete_set
    end
  end

  test 'after 5 sets if #total_reps is 25 or higher reset_failure' do
    @workout.exercises[:squats][:failures] = 2
    @workout.exercises[:squats][:reps] = '55555'
    @workout.complete_set
    assert_equal 0, @workout.exercises[:squats][:failures]
  end

  test 'after 5 sets if #total_reps is 25 or higher increase weight 5lbs' do
    @workout.exercises[:squats][:reps] = '55555'
    @workout.complete_set
    assert_equal 105, @workout.exercises[:squats][:weight]
  end

  test 'after 3 failures the weight should be dropped 10% rounded down to nearest 5' do
    @workout.exercises[:squats][:failures] = 2
    @workout.exercises[:squats][:reps] = '55433'
    @workout.complete_set
    assert_equal 0, @workout.exercises[:squats][:failures]
    assert_equal 90, @workout.exercises[:squats][:weight]
  end

  test 'after 1 set of deadlifts if #total_reps < 5 #increment_failure' do
    @workout.state = 'deadlifts'
    @workout.exercises[:deadlifts][:failures] = 0
    @workout.exercises[:deadlifts][:reps] = '3'
    assert_difference '@workout.exercises[:deadlifts][:failures]', +1 do
      @workout.complete_set
    end
  end

  test 'after 3 failures of deadlifts the weight should be dropped 10% rounded down to nearest 5' do
    @workout.state = 'deadlifts'
    @workout.exercises[:deadlifts][:failures] = 2
    @workout.exercises[:deadlifts][:reps] = '3'
    @workout.complete_set
    assert_equal 0, @workout.exercises[:deadlifts][:failures]
    assert_equal 90, @workout.exercises[:deadlifts][:weight]
  end

  test 'after 1 set of deadlifts if #total_reps > 4 #increase_weight' do
    @workout.state = 'deadlifts'
    @workout.exercises[:deadlifts][:reps] = '5'
    @workout.complete_set
    assert_equal 110, @workout.exercises[:deadlifts][:weight]
  end

  test 'failure is not increased until the final set is completed' do
    @workout.exercises[:squats][:reps] = '1'
    @workout.complete_set
    assert_equal 0, @workout.exercises[:squats][:failures]
  end

  test 'after exercise is complete, reset reps' do
    @workout.exercises[:squats][:reps] = '55555'
    @workout.complete_set
    assert_blank @workout.exercises[:squats][:reps]
  end
end
