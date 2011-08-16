require 'test_helper'

class BatchControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get import" do
    get :import
    assert_response :success
  end

  test "should get match" do
    get :match
    assert_response :success
  end

  test "should get trunc" do
    get :trunc
    assert_response :success
  end

  test "should get schedule_D" do
    get :schedule_D
    assert_response :success
  end

end
