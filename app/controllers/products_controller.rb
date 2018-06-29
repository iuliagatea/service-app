class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_tenant, only: [:show, :edit, :update, :destroy, :new, :create]
  before_action :verify_tenant
  
  # GET /products
  # GET /products.json
  def index
    @products = Product.by_tenant(params[:tenant_id])
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @statuses = Status.by_product(params[:id]).uniq
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
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    user = User.find_by_email(params[:user]["email"]).ids.first
    if user.blank?
       @user   = User.new( user_params )
      # ok to create user, member
      if @user.save_and_invite_member() && @user.create_member( member_params )
        flash[:notice] = "New member added and invitation email sent to #{@user.email}."
      else
        flash[:error] = "errors occurred!"
        @member = Member.new( member_params ) # only used if need to revisit form
        render :new
      end
      user = @user.id
    end
    @product.user_id = user
    @product.statuses << params[:status]["id"]
    respond_to do |format|
      if @product.save
        format.html { redirect_to tenant_products_url, notice: 'Product was successfully created.' }
      else
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
        format.html { redirect_to tenant_products_url, notice: 'Product was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to tenant_products_url, notice: 'Product was successfully destroyed.' }
    end
  end
  
  def by_member
    @user = User.find(params[:user_id])
    @products = @user.products
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def set_tenant
      @tenant = Tenant.find(params[:tenant_id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:code, :name, :expected_completion_date, :tenant_id)
    end

    def verify_tenant
      unless params[:tenant_id] == Tenant.current_tenant_id.to_s
        redirect_to :root, 
            flash: { error: 'You are not authorized to acces any organization other than your own' }
      end
    end
    
    def member_params()
      params.require(:member).permit(:first_name, :last_name)
    end
  
    def user_params()
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
