require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get exercises_show_url
    assert_response :success
  end
end
