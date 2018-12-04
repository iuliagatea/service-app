class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_tenant, only: %i[show edit update destroy new create]
  before_action :verify_tenant
  before_action :verify_user, except: %i[show index]

  # GET /products
  # GET /products.json
  def index
    if current_user.is_admin
      @products = Product.by_tenant(params[:tenant_id]).paginate(page: params[:page], per_page: 10)
    else
      @products = current_user.products.paginate(page: params[:page], per_page: 10)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    logger.debug "Showing products of tenant with id #{params[:tenant_id]} for user #{current_user.email}"
    @product_statuses = @product.product_statuses
    @estimates = @product.estimates
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@product.code}_product_card",
               template: 'products/product_pdf.html.erb',
               layout: 'layouts/pdf.html.erb',
               show_as_html: params[:debug].present?
      end
    end
  end

  def new
    @product = Product.new
    @statuses = Status.by_tenant(params[:tenant_id])
  end

  def edit
    @user = Product.find(params[:id]).user
    @status = Status.find(ProductStatus.last_by_product(params[:id]))
    @statuses = Status.by_tenant(params[:tenant_id])
    @estimates = @product.estimates
  end

  def create
    @product = Product.new(product_params)
    logger.debug "New product: #{@product.attributes.inspect}"
    logger.debug "Product should be valid: #{@product.valid?}"
    
    @user = User.find_by_email(params[:user]['email']).ids.first
    if @user.blank?
      @user   = User.new( user_params )
      logger.debug "New user, member: #{@user.attributes.inspect}"
     
      # ok to create user, member
      if @user.save_and_invite_member() && @user.create_member( member_params )
        logger.debug "New member added and invitation email sent to #{@user.email}."
        flash[:notice] = "New member added and invitation email sent to #{@user.email}."
      else
        logger.error "Errors occurred while creating user #{@user.errors}"
        flash[:error] = 'errors occurred!'
        @member = Member.new( member_params ) # only used if need to revisit form
        render :new
      end
    else
      @user = User.find(User.find_by_email(params[:user]['email']).ids.first)
      @user.tenants << Tenant.find(Tenant.current_tenant_id) unless @user.tenants.include?(Tenant.find(Tenant.current_tenant_id))
    end
    @product.user_id = @user.id
    status = Status.find(params[:status]['id'])
    @product.statuses << status
    respond_to do |format|
      if @product.save
        UserNotifier.send_status_change_email(User.find(@user), @product, "#{@tenant.name} - New product #{@product.name}").deliver_now 
        logger.info 'The product was saved and now the user is going to be redirected...'
        format.html { redirect_to tenant_products_url, notice: 'Product was successfully created.' }
      else
        logger.error "Errors occurred while creating product #{@product.errors}."
        format.html { render :new }
      end
    end
  end

  def update
    user = User.find_by_email(params[:user]['email']).ids.first
    @product.user_id = user
    status = Status.find(params[:status]['id'])
    last_status = @product.last_status
    @product.statuses << status unless @product.last_status == status 
    respond_to do |format|
      if @product.update(product_params)
        logger.info 'The product was updated and now the user is going to be redirected...'
        if status.send_email and last_status != status 
          logger.info 'Send email to customer for status change'
          UserNotifier.send_status_change_email(User.find(user), @product, "#{@tenant.name} - Status updated for product #{@product.name}").deliver_now 
        end
        format.html { redirect_to tenant_products_url, notice: 'Product was successfully updated.'}
      else
        logger.error "Errors occurred while updating product #{@product.attributes.inspect}."
        format.html { render :edit }
      end
    end
  end

  def destroy
    logger.debug "Deleting product #{@product.attributes.inspect}"
    @product.destroy
    respond_to do |format|
      logger.info 'The product was deleted and now the user is going to be redirected...'
      format.html { redirect_to tenant_products_url, notice: 'Product was successfully destroyed.' }
    end
  end
  
  def by_member
    @user = User.find(params[:user_id])
    if current_user.is_admin?
      @products = @user.products.by_tenant_and_user(params[:tenant_id], params[:user_id]).paginate(page: params[:page], per_page: 10)
    else
      @products = @user.products.paginate(page: params[:page], per_page: 10)
    end
  end
  
  def send_product_card
    @product = Product.find(params[:product_id])
    @tenant = Tenant.find(params[:tenant_id])
    logger.debug "Send product card via email #{@product.attributes.inspect}"
    UserNotifier.send_product_card_email_pdf(User.find(@product.user), @product, "#{@tenant.name} - Product card - #{@product.name}").deliver_now 
    redirect_to tenant_product_path(@product.id, tenant_id: @product.tenant_id), notice: 'Product card sent successfully.' 
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_tenant
    Tenant.set_current_tenant(Tenant.find(params[:tenant_id])) unless current_user.is_admin?
    @tenant = Tenant.find(params[:tenant_id])
  end
    
  def product_params
    params.require(:product).permit(:code, :name, :expected_completion_date, :tenant_id, :comments, estimates_attributes: %i[id name quantity price value _destroy])
  end

  def verify_tenant
    unless params[:tenant_id] == Tenant.current_tenant_id.to_s
      redirect_to :root, 
          flash: { error: 'You are not authorized to acces any organization other than your own' }
    end
  end
    
  def verify_user
    unless params[:user_id] == current_user.to_s or current_user.is_admin
      redirect_to :root, 
          flash: { error: 'You are not authorized to do this action' }
    end
  end
    
  def member_params()
    params.require(:member).permit(:first_name, :last_name)
  end
  
  def user_params()
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
