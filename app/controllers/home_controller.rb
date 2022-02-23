# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, only: %i[index contact demand_offer]
  skip_before_action :verify_authenticity_token, only: [:demand_offer]

  def index
    redirect_to tenant_products_path(current_user.tenants.first) if current_user
  end

  def contact
    # logger.debug "Demand offer form for tenant #{Tenant.current_tenant.attributes.inspect}"
    @tenant = Tenant.find(params[:tenant])
  end

  def demand_offer
    if product
      params[:message] << "<hr> This message refers to #{view_context.link_to "#{product.code} #{product.name}",
                                                                              product_url(product)} <hr>"
    end
    @subject = params[:title] == 'Demand offer' ? 'New offer demand' : 'New message'
    UserNotifier.send_email(params[:email], tenant.users.first.email,
                            "#{@subject} from #{params[:name]} - #{params[:subject]}", params[:message]).deliver_now
    redirect_to root_path, notice: 'Email was sent successfully.'
  end
end
