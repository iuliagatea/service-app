# frozen_string_literal: true

class TenantMemberProductsController < ApplicationController
  before_action :set_current_tenant
  before_action :user

  def index
    @products = products.paginate(page: params[:page], per_page: 10)
  end

  private

  def products
    @products ||= current_user.is_admin ? tenant.products.where(user_id: params[:user_id]) : user.products
  end

  def user
    @user ||= User.find(params[:user_id])
  end
end
