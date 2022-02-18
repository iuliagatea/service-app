# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, only: %i[business contact demand_offer]
  skip_before_action :verify_authenticity_token, only: [:demand_offer]

  def index
    if current_user
      logger.info 'Opening index..'
      Tenant.set_current_tenant session[:tenant_id]
      params[:tenant_id] = session[:tenant_id]
      @user_tenants = current_user.tenants
      @products = paginate(products, params[:page])
    end
    search if params[:query].present?
  end

  def business; end

  def contact
    logger.debug "Demand offer form for tenant #{tenant.attributes.inspect}"
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

  private

  # def tenant
  #   @tenant ||= Tenant.find(params[:tenant_id])
  # end

  def search
    @tenants = Tenant.search_any_word(params[:query]).sort_by { |t| [t.rating.stars, t.name] }
    @tenants.delete(Tenant.current_tenant)
    @tenants = @tenants.search_categories(params[:categories]) if params[:categories].present?
    @categories = []
    if @tenants.empty?
      flash[:notice] = 'No result for your search'
    else
      @tenants = paginate(@tenants, params[:page])
      @tenants.each do |t|
        t.categories.each do |c|
          @categories << Category.find(c.id) unless @categories.include?(Category.find(c.id))
        end
      end
      @categories.sort!
    end
  end
end
