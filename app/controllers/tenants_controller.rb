class TenantsController < ApplicationController
  before_action :set_tenant
  
  
  def edit
    @categories = Category.where(entity: 'Tenants')
  end
  
  def show
    @categories = @tenant.categories
  end
  
  def update
    respond_to do |format|
      Tenant.transaction do
        if @tenant.update(tenant_params)
          if @tenant.plan == 'premium' && @tenant.payment.blank?
            logger.debugg "Updating plan for tennant #{@tenant.attributes.inspect}"
            @payment = Payment.new({ email: tenant_params["email"],
            token: params[:payment]["token"],
            tenant: @tenant })
            begin
              @payment.process_payment
              @payment.save
            rescue Exception => e
              flash[:error] = e.message
              @payment.destroy
              @tenant.plan = 'free'
              @tenant.save
              redirect_to edit_tenant_path(@tenant) and return
            end
          end
          format.html { redirect_to edit_plan_path, notice: 'Tenant was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def change
    @tenant = Tenant.find(params[:id])
    Tenant.set_current_tenant @tenant.id
    session[:tenant_id] = Tenant.current_tenant.id
    redirect_to home_index_path, notice: "Switched to organization #{@tenant.name}"
  end
  
  private
  
  def set_tenant
    Tenant.set_current_tenant(Tenant.find(params[:tenant_id])) unless current_user.is_admin?
    @tenant = Tenant.find(Tenant.current_tenant_id)
  end
  
  def tenant_params
    params.require(:tenant).permit(:name, :plan, :description, :keywords, category_ids: [])
  end

end