class UsersController < ApplicationController
  before_action :set_tenant
  
  def tenants
    @user_tenants = @user.tenants
    @user_products = @user.products
  end
  
  private
  
  def set_tenant
    @tenant = Tenant.find(Tenant.current_tenant_id)
  end
  
end