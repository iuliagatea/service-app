class UserTenantsController < ApplicationController
  before_action :set_user_tenant, only: [:show, :edit, :update, :destroy]

  # GET /user_tenants
  # GET /user_tenants.json
  def index
    @user_tenants = UserTenant.all
  end

  # GET /user_tenants/1
  # GET /user_tenants/1.json
  def show
  end

  # GET /user_tenants/new
  def new
    @user_tenant = UserTenant.new
  end

  # GET /user_tenants/1/edit
  def edit
  end

  # POST /user_tenants
  # POST /user_tenants.json
  def create
    user = User.find_by_email(params[:email])
    if user.blank?
      user = User.new_from_lookup(params[:email])
      user.save
    end
    @user_tenant = UserTenant.new(user_tenant_params)

    respond_to do |format|
      if @user_tenant.save
        format.html { redirect_to @user_tenant, notice: 'User tenant was successfully created.' }
        format.json { render :show, status: :created, location: @user_tenant }
      else
        format.html { render :new }
        format.json { render json: @user_tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_tenants/1
  # PATCH/PUT /user_tenants/1.json
  def update
    respond_to do |format|
      if @user_tenant.update(user_tenant_params)
        format.html { redirect_to @user_tenant, notice: 'User tenant was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_tenant }
      else
        format.html { render :edit }
        format.json { render json: @user_tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_tenants/1
  # DELETE /user_tenants/1.json
  def destroy
    @user_tenant.destroy
    respond_to do |format|
      format.html { redirect_to user_tenants_url, notice: 'User tenant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_tenant
      @user_tenant = UserTenant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_tenant_params
      params.require(:user_tenant).permit(:user_id, :tenant_id)
    end
end
