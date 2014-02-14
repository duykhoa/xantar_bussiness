require 'test_helper'

class BussinessesControllerTest < ActionController::TestCase
  setup do
    @bussiness = bussinesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bussinesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bussiness" do
    assert_difference('Bussiness.count') do
      post :create, bussiness: {  }
    end

    assert_redirected_to bussiness_path(assigns(:bussiness))
  end

  test "should show bussiness" do
    get :show, id: @bussiness
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bussiness
    assert_response :success
  end

  test "should update bussiness" do
    patch :update, id: @bussiness, bussiness: {  }
    assert_redirected_to bussiness_path(assigns(:bussiness))
  end

  test "should destroy bussiness" do
    assert_difference('Bussiness.count', -1) do
      delete :destroy, id: @bussiness
    end

    assert_redirected_to bussinesses_path
  end
end
