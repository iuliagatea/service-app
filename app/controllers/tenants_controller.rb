# frozen_string_literal: true

class TenantsController < ApplicationController
  skip_before_action :authenticate_tenant!, only: %i[search]
  before_action :set_current_tenant,  only: %i[edit update contact]
  # before_action :must_be_customer

  def edit
    logger.debug "Edit tenant #{@tenant.attributes.inspect}"
    @categories = Category.where(entity: 'tenant')
  end

  def show
    @tenant = Tenant.find(params[:id])
    logger.debug "Show tenant #{@tenant.attributes.inspect}"
    @categories = @tenant.categories
    @user_review = @tenant.reviews.where(user_id: current_user)
    @reviews = @tenant.reviews.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    @reviews.unshift(@user_review)
  end

  def update
    respond_to do |format|
      Tenant.transaction do
        if @tenant.update(tenant_params)
          if @tenant.plan == 'premium' && @tenant.payment.blank?
            logger.debugg "Updating plan for tenant #{@tenant.attributes.inspect}"
            @payment = Payment.new(email: tenant_params['email'],
                                   token: params[:payment]['token'],
                                   tenant: @tenant)
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

  def contact
    logger.debug "Contact form for tenant #{@tenant.attributes.inspect}"
    @product = Product.find(params[:product_id]) if params[:product_id]
  end

  def search
    @tenants = TenantSearch.new(params).search
    return flash[:notice] = 'No result for your search' unless @tenants

    @tenants = paginate(@tenants, params[:page]) if @tenants
  end

  private

  def tenant_params
    params.require(:tenant).permit(:name, :plan, :description, :keywords, category_ids: [])
  end

  def set_current_tenant
    @tenant ||= Tenant.current_tenant
  end
end
