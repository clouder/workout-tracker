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
end
