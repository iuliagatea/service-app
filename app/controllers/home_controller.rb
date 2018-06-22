class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :index ]

  def index
    if current_user
      if session[:tenant_id]
        Tenant.set_current_tenant session[:tenant_id]
      else
        Tenant.set_current_tenant current_user.tenants.first
      end
      @user = User.find(current_user)
      if current_user.is_admin?
        @tenant = Tenant.current_tenant
        params[:tenant_id] = @tenant.id
        @products = Product.where(tenant_id: @tenant)
      else
        @tenants = @user.tenants
        @products = @user.products
      end
    end
  end
end
