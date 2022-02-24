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

  def products
    @products ||= current_user.is_admin ? Tenant.current_tenant.products : current_user.products
  end

  def must_be_customer
    return if tenant.users.include?(current_user)

    not_authorized_redirect
  end

  def verify_admin
    return if current_user.is_admin

    not_authorized_redirect
  end

  def verify_user
    return unless current_user && !((params[:user_id].to_i == current_user.id) || current_user.is_admin)

    not_authorized_redirect
  end

  def verify_tenant
    return if params[:tenant_id].to_i == Tenant.current_tenant_id

    not_authorized_redirect
  end

  def paginate(resource, page, per_page = nil)
    per_page ||= 10
    resource.paginate(page: page, per_page: per_page)
  end

  private

  def not_authorized_redirect
    redirect_to :root,
                flash: { error: 'You are not authorized to do this action' }
  end
end
