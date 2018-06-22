class StatusesController < ApplicationController
  before_action :set_tenant
  before_action :require_admin
  
  def index
    @statuses = Status.where("tenant_id = :tenant", { tenant: @tenant.id })
    # @statuses = Status.all
  end
  
  def new
    @status = Status.new
  end
  
  def create
    @status = Status.new(status_params)
    @status.tenant_id = Tenant.current_tenant_id
    if @status.save
      flash[:success] = "Status was created successfully"
      redirect_to statuses_path
    else
      render 'new'
    end
  end
  
  def edit
    @status = Status.find(params[:id])
  end
  
  def update
    @status = Status.find(params[:id])
    @status.tenant_id = Tenant.current_tenant_id
    if @status.update(status_params)
      flash[:success] = "Status name was successfully updated"
      redirect_to statuses_path(@status)
    else
      render 'edit'
    end
  end
  
  def show
    @status = Status.find(params[:id])
  end
  
  private
  def status_params
    params.require(:status).permit(:name, :color)
  end
  
  def set_tenant
    @tenant = Tenant.find(Tenant.current_tenant_id)
  end
  
  def require_admin
    if !current_user || !current_user.is_admin?
      flash[:danger] = "Only admins can perform that action"
      redirect_to root_path
    end
  end
end