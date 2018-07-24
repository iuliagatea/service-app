class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :index, :business, :contact, :demand_offer ]
  skip_before_action :verify_authenticity_token, :only => [ :demand_offer ]
  
  def index
    if current_user
      if session[:tenant_id]
        Tenant.set_current_tenant session[:tenant_id]
      else
        Tenant.set_current_tenant current_user.tenants.first
      end
      logger.info "Opening index.."
      @tenant = Tenant.current_tenant
      params[:tenant_id] = @tenant.id
      @user_tenants = current_user.tenants
      if current_user.is_admin
        @products = Product.by_tenant(params[:tenant_id]).paginate(page: params[:page], per_page: 10)
      else
        @products = current_user.products.paginate(page: params[:page], per_page: 10)
      end
    end
    if params[:query].present?
      search_by = params[:query]
      @tenants = Tenant.search_any_word(search_by).paginate(page: params[:page], per_page: 10)
      if params[:categories].present?
        @tenants = @tenants.search_categories(params[:categories]).paginate(page: params[:page], per_page: 10)
      end
      @categories = []
      if @tenants.empty?
        flash[:notice] = "No result for your search"
      else
        @tenants.each do |t|
          t.categories.each do |c|
            @categories << Category.find(c.id) unless @categories.include?(Category.find(c.id))
          end
        end
        @categories.sort!
      end
    end
  end
  
  def business
    
  end
  
  def contact
    @tenant = Tenant.find(params[:tenant])
  end
  
  def demand_offer
    @tenant = Tenant.find(params[:tenant])
    @product = Product.find(params[:product_id]) if params[:product_id]
    params[:message] << "<hr> This message refers to #{ link_to @product.code @product.name, product_url(@product) }<hr>" if @product
    UserNotifier.demand_offer(params[:email], @tenant.users.first.email, "New offer demand from #{params[:name]} - #{params[:subject]}", params[:message]).deliver_now 
    redirect_to root_path, notice: 'Email was sent successfully.' 
  end
  
end
