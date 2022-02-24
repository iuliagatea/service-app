# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, only: %i[index contact demand_offer]
  skip_before_action :verify_authenticity_token, only: [:demand_offer]

  def index
    redirect_to tenant_products_path(current_user.tenants.first) if current_user
  end
end
