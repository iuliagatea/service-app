# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!

  def index
    redirect_to tenant_products_path(current_user.tenants.first) if current_user
  end
end
