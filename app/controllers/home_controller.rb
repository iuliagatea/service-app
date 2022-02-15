class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, only: %i[index business contact demand_offer]
  skip_before_action :verify_authenticity_token, only: [:demand_offer]
  
  def index
    if current_user
      tenant_id = session[:tenant_id] ? session[:tenant_id] : current_user.tenants.first
      Tenant.set_current_tenant tenant_id if Tenant.current_tenant_id != tenant_id
      logger.info 'Opening index..'
      @tenant = Tenant.current_tenant
      params[:tenant_id] = @tenant.id
      @user_tenants = current_user.tenants
      @products = products.paginate(page: params[:page], per_page: 10)
    end
    if params[:query].present?
      search(params)
    end
  end
  
  def business
  end
  
  def contact
    @tenant = Tenant.find(params[:tenant])
    logger.debug "Demand offer form for tenant #{@tenant.attributes.inspect}"
  end
  
  def demand_offer
    @tenant = Tenant.find(params[:tenant])
    @product = Product.find(params[:product]) if params[:product]
    @message = params[:message] 
    @message << "<hr> This message refers to #{ view_context.link_to @product.code + " " + @product.name, product_url(@product) } <hr>" if @product
    @subject = params[:title] == 'Demand offer' ? 'New offer demand' : 'New message'
    UserNotifier.send_email(params[:email], @tenant.users.first.email, "#{@subject} from #{params[:name]} - #{params[:subject]}", @message).deliver_now 
    redirect_to root_path, notice: 'Email was sent successfully.'
  end

  private
  def products
    @products = current_user.is_admin ? @tenant.products : current_user.products
  end

  def search(params)
    search_by = params[:query]
    @tenants = Tenant.search_any_word(search_by).sort_by{ |t| [t.rating.stars, t.name]}
    @tenants.delete(Tenant.current_tenant)
    if params[:categories].present?
      @tenants = @tenants.search_categories(params[:categories])
    end
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
