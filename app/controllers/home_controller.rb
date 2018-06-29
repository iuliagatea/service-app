class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :index ]

  def index
    if current_user
      if session[:tenant_id]
        Tenant.set_current_tenant session[:tenant_id]
      else
        Tenant.set_current_tenant current_user.tenants.first
      end
      @tenant = Tenant.current_tenant
      params[:tenant_id] = @tenant.id
      if current_user.is_admin
        @products = Product.by_tenant(params[:tenant_id])
      else
        @products = current_user.products
      end
    end
  end
end
