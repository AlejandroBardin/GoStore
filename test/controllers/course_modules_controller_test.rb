require "test_helper"

class CourseModulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get course_modules_index_url
    assert_response :success
  end
end
