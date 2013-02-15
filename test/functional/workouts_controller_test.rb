require 'test_helper'

class WorkoutsControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
    assert_select "a[href=#{workout_path}]", 'Start Workout'
  end
end
