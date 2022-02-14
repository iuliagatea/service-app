class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_tenant!
  
     ##    milia defines a default max_tenants, invalid_tenant exception handling
     ##    but you can override these if you wish to handle directly
  rescue_from ::Milia::Control::MaxTenantExceeded, :with => :max_tenants
  rescue_from ::Milia::Control::InvalidTenantAccess, :with => :invalid_tenant

  def tenant
    Tenant.set_current_tenant params[:tenant_id] unless Tenant.current_tenant
    @tenant ||= Tenant.current_tenant
  end

  def product
    @product ||= Product.find(params[:product_id])
  end

  def user
    @user ||= User.find(params[:user_id])
  end

  def verify_admin
    unless current_user.is_admin
      redirect_to :root,
                  flash: { error: 'You are not authorized to do this action' }
    end
  end

  def verify_user
    if current_user
      unless params[:user_id] == current_user.to_s or current_user.is_admin
        redirect_to :root,
                    flash: { error: 'You are not authorized to do this action' }
      end
    end
  end

  def verify_tenant
    unless params[:tenant_id] == Tenant.current_tenant_id.to_s
      redirect_to :root,
                  flash: { error: 'You are not authorized to acces any organization other than your own' }
    end
  end
end
