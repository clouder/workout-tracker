require 'test_helper'

class WorkoutsControllerTest < ActionController::TestCase
  test 'get index' do
    get :index
    assert_response :success
    assert_select "a[href=#{workout_path}]", 'Start Workout'
  end

  test 'get show' do
    get :show
    assert_response :success
    assert_not_nil (assigns :workout), '@workout should not be nil'
  end
end
