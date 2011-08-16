require 'test_helper'

class RoundtripsControllerTest < ActionController::TestCase
  setup do
    @roundtrip = roundtrips(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roundtrips)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roundtrip" do
    assert_difference('Roundtrip.count') do
      post :create, :roundtrip => @roundtrip.attributes
    end

    assert_redirected_to roundtrip_path(assigns(:roundtrip))
  end

  test "should show roundtrip" do
    get :show, :id => @roundtrip.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @roundtrip.to_param
    assert_response :success
  end

  test "should update roundtrip" do
    put :update, :id => @roundtrip.to_param, :roundtrip => @roundtrip.attributes
    assert_redirected_to roundtrip_path(assigns(:roundtrip))
  end

  test "should destroy roundtrip" do
    assert_difference('Roundtrip.count', -1) do
      delete :destroy, :id => @roundtrip.to_param
    end

    assert_redirected_to roundtrips_path
  end
end
