require 'test_helper'

class TypicalUseTest < ActionDispatch::IntegrationTest
  test 'Start a workout' do
    get '/'
    assert_response :success

    # user clicks start workout
  end
end
