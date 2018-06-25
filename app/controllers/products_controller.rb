class ProductsController < ApplicationController
  before_action :set_tenant

  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.users << current_user
    @product.statuses << product_params[:status]
    respond_to do |format|
      if @product.save
        format.html { redirect_to root_url, notice: 'Product was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end
  
  def index
    @product = Product.find(params[:id])
    @product_statuses = @product.statuses
  end
  
  def show
    @product = Product.find(params[:id])
    @product_statuses = @product.statuses
  end
  
  def edit
    @product = Product.find(params[:id])
    @statuses = Status.where("tenant_id = :tenant", { tenant: @tenant.id })
  end
  
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to root_url, notice: 'Product was successfully updated.' }
        # @product_status = ProductStatus.create(product: @product, status: product_params[:status])
      else
        format.html { render :edit }
      end
    end
  end
  
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_tenant
    @tenant = Tenant.find(Tenant.current_tenant_id)
  end
  
  def product_params
    params.require(:product).permit(:code, :name, :status, :tenant_id)
  end
end