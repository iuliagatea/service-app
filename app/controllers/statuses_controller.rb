class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  before_action :set_tenant, only: [:show, :edit, :update, :destroy, :new, :create]
  before_action :verify_tenant
  before_action :verify_user, except: [:products]

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.by_tenant(params[:tenant_id]).paginate(page: params[:page], per_page: 10)
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
  end

  # GET /statuses/new
  def new
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = Status.new(status_params)

    respond_to do |format|
      if @status.save
        format.html { redirect_to tenant_statuses_url, notice: 'Status was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to tenant_statuses_url, notice: 'Status was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to tenant_statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def products
    @user = User.find(current_user)
    @status = Status.find(params[:status_id])
    if @user.is_admin
      @products = @status.products_with_status.paginate(page: params[:page], per_page: 10)
    else
      @products = @status.products_with_status_by_user(@user).paginate(page: params[:page], per_page: 10)
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:name, :color, :tenant_id, :is_active)
    end
    
    def set_tenant
      Tenant.set_current_tenant(Tenant.find(params[:tenant_id])) unless current_user.is_admin?
      @tenant = Tenant.find(params[:tenant_id])
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

end
