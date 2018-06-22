require 'test_helper'

class UserTenantsControllerTest < ActionController::TestCase
  setup do
    @user_tenant = user_tenants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_tenants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_tenant" do
    assert_difference('UserTenant.count') do
      post :create, user_tenant: { tenant_id: @user_tenant.tenant_id, user_id: @user_tenant.user_id }
    end

    assert_redirected_to user_tenant_path(assigns(:user_tenant))
  end

  test "should show user_tenant" do
    get :show, id: @user_tenant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_tenant
    assert_response :success
  end

  test "should update user_tenant" do
    patch :update, id: @user_tenant, user_tenant: { tenant_id: @user_tenant.tenant_id, user_id: @user_tenant.user_id }
    assert_redirected_to user_tenant_path(assigns(:user_tenant))
  end

  test "should destroy user_tenant" do
    assert_difference('UserTenant.count', -1) do
      delete :destroy, id: @user_tenant
    end

    assert_redirected_to user_tenants_path
  end
end
