# frozen_string_literal: true

class TenantMemberProductsController < ApplicationController
  def index
    @products = products.paginate(page: params[:page], per_page: 10)
  end

  private

  def products
    @products = user.is_admin ? Tenant.current_tenant.products.where(user_id: params[:user_id]) : user.products
  end

  def user
    @user = User.find(params[:user_id])
  end
end
