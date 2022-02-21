# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_tenant!

  ##    milia defines a default max_tenants, invalid_tenant exception handling
  ##    but you can override these if you wish to handle directly
  rescue_from ::Milia::Control::MaxTenantExceeded, with: :max_tenants
  rescue_from ::Milia::Control::InvalidTenantAccess, with: :invalid_tenant

  # def tenant
  #   @tenant = Tenant.current_tenant if Tenant.current_tenant != @tenant
  # end

  def products
    @products ||= current_user.is_admin ? Tenant.current_tenant.products : current_user.products
  end

  # def current_tenant(tenant_param)
  #   tenant_id = tenant_param || current_user.tenants.first.id
  #   Tenant.set_current_tenant tenant_id if Tenant.current_tenant_id != tenant_id
  #
  #   Tenant.current_tenant
  # end

  def product
    @product ||= Product.find(params[:product_id])
  end

  def user
    @user ||= User.find(params[:user_id])
  end

  def must_be_customer
    return if tenant.users.include?(current_user)

    redirect_to :root,
                flash: { error: 'You are not authorized to do this action' }
  end

  def verify_admin
    return if current_user.is_admin

    redirect_to :root,
                flash: { error: 'You are not authorized to do this action' }
  end

  def verify_user
    return unless current_user && !((params[:user_id] == current_user.to_s) || current_user.is_admin)

    redirect_to :root,
                flash: { error: 'You are not authorized to do this action' }
  end

  def verify_tenant
    return if params[:tenant_id] == Tenant.current_tenant_id.to_s

    redirect_to :root,
                flash: { error: 'You are not authorized to access any organization other than your own' }
  end

  def paginate(resource, page)
    resource.paginate(page: page, per_page: 10)
  end
end
