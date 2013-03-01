require 'test_helper'

class TypicalUseTest < ActionDispatch::IntegrationTest
  test 'Start a workout' do
    get root_path
    assert_response :success
    assert_select "a[href=#{workout_path}]", 'Start Workout'
    # click the 'Start Workout' link
    get workout_path
    assert_select 'h1', 'Squats - 100 lbs []'
    assert_select "form[action=#{workout_path}]", 5 do |elm|
      elm.each do |elm|
        assert_select elm, 'input[type=hidden][name=reps]', 1
        assert_select elm, 'input[type=submit][value=?]', /\A\d\z/, 1
      end
    end
    # click the button '5' button
    put workout_path, reps: 5
    # skip the break since computers don't get tired
    get workout_path
    assert_select 'h1', 'Squats - 100 lbs [5]'
    # fake a lot of sets at once
    put workout_path reps: 555
    get workout_path
    assert_select 'h1', 'Squats - 100 lbs [5555]'
    # one more time to complete squats
    put workout_path reps: 5
    get workout_path
    assert_select 'h1', 'Benchpress - 100 lbs []'
    # complete benchpress in one go
    put workout_path reps: 55555
    get workout_path
    assert_select 'h1', 'Rows - 100 lbs []'
    # complete rows in one go
    put workout_path reps: 55555
    get workout_path
    assert_select 'h1', 'Squats - 105 lbs []'
  end

  test 'start an exercise that has no previous failure' do
    put_via_redirect workout_path, reps: 5
    assert_select 'meta[http-equiv][content^=90]'
    assert_select 'h1', '90 Second Break'
  end

  test 'start an exercise that was failed once previously' do
    # fake a previous failure
    workout = Workout.first
    workout.exercises[workout.exercise.to_sym][:failures] = 1
    workout.save
    # finished a set and clicked a rep button
    put_via_redirect workout_path, reps: 5
    assert_select 'meta[http-equiv][content^=180]'
    assert_select 'h1', '180 Second Break'
  end

  test 'start an exercise that was failed twice previously' do
    # fake 2 previous failures
    workout = Workout.first
    workout.exercises[workout.exercise.to_sym][:failures] = 2
    workout.save
    # finish a set and clicked a rep button
    put_via_redirect workout_path, reps: 5
    assert_select 'meta[http-equiv][content^=300]'
    assert_select 'h1', '300 Second Break'
  end
end
