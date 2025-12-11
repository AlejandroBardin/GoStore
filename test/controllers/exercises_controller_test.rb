require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get exercise_url(exercises(:one))
    assert_response :success
  end
end
