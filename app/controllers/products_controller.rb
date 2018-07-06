class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_tenant, only: [:show, :edit, :update, :destroy, :new, :create]
  before_action :verify_tenant
  before_action :verify_user, except: [:show, :index]

  # GET /products
  # GET /products.json
  def index
    @user = User.find(current_user)
    if @user.is_admin
      @products = Product.by_tenant(params[:tenant_id]).paginate(page: params[:page], per_page: 10)
    else
      @products = @user.products.paginate(page: params[:page], per_page: 10)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    logger.debug "Showing products of tenant with id #{params[:tenant_id]} for user #{current_user.email}"
    @statuses = Status.by_product(params[:id]).uniq
    @estimates = @product.estimates
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@product.code}_product_card",   # Excluding ".pdf" extension.
               template: 'products/product_pdf.html.erb',
               layout: 'layouts/pdf.html.erb',
               show_as_html: params[:debug].present?
      end
    end
  end

  # GET /products/new
  def new
    @product = Product.new
    @statuses = Status.by_tenant(params[:tenant_id])
  end

  # GET /products/1/edit
  def edit
    @user = Product.find(params[:id]).user
    @status = Status.find(ProductStatus.last_by_product(params[:id]))
    @statuses = Status.by_tenant(params[:tenant_id])
    @estimates = @product.estimates
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    logger.debug "New product: #{@product.attributes.inspect}"
    logger.debug "Product should be valid: #{@product.valid?}"
    
    @user = User.find_by_email(params[:user]["email"]).ids.first
    if @user.blank?
      @user   = User.new( user_params )
      logger.debug "New user,member: #{@user.attributes.inspect}"
     
      # ok to create user, member
      if @user.save_and_invite_member() && @user.create_member( member_params )
        logger.debug "New member added and invitation email sent to #{@user.email}."
        flash[:notice] = "New member added and invitation email sent to #{@user.email}."
      else
        logger.error "Errors occurred while creating user #{@user.errors}"
        flash[:error] = "errors occurred!"
        @member = Member.new( member_params ) # only used if need to revisit form
        render :new
      end
    else
      @user.tenants << Tenant.find(Tenant.current_tenant_id)
    end
    @product.user_id = @user
    status = Status.find(params[:status]["id"])
    @product.statuses << status
    respond_to do |format|
      if @product.save
        logger.info "The product was saved and now the user is going to be redirected..."
        format.html { redirect_to tenant_products_url, notice: 'Product was successfully created.' }
      else
        logger.error "Errors occurred while creating product #{@product.errors}."
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    user = User.find_by_email(params[:user]["email"]).ids.first
    @product.user_id = user
    status = Status.find(params[:status]["id"])
    @product.statuses << status
    respond_to do |format|
      if @product.update(product_params)
        logger.info "The product was updated and now the user is going to be redirected..."
        format.html { redirect_to tenant_products_url, notice: 'Product was successfully updated.'}
      else
        logger.error "Errors occurred while updating product #{@product.attributes.inspect}."
        format.html { render :edit }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    logger.debug "Deleting product #{@product.attributes.inspect}"
    @product.destroy
    respond_to do |format|
      logger.info "The product was deleted and now the user is going to be redirected..."
      format.html { redirect_to tenant_products_url, notice: 'Product was successfully destroyed.' }
    end
  end
  
  def by_member
    @user = User.find(params[:user_id])
    if current_user.is_admin?
      @products = @user.products.by_tenant(params[:tenant_id]).paginate(page: params[:page], per_page: 10)
    else
      @products = @user.products.paginate(page: params[:page], per_page: 10)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def set_tenant
      Tenant.set_current_tenant(Tenant.find(params[:tenant_id])) unless current_user.is_admin?
      @tenant = Tenant.find(params[:tenant_id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:code, :name, :expected_completion_date, :tenant_id, :comments, estimates_attributes: [:id, :name, :quantity, :price, :value, :_destroy])
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
