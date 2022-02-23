# frozen_string_literal: true

class TenantsController < ApplicationController
  skip_before_action :authenticate_tenant!, only: %i[search contact send_email]
  before_action :find_tenant,  except: %i[search]
  # before_action :must_be_customer

  def edit
    logger.debug "Edit tenant #{@tenant.attributes.inspect}"
    @categories = Category.where(entity: 'tenant')
  end

  def show
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
  end

  def send_email
    @product = Product.find(params[:product_id]) if params[:product_id]
    if @product
      params[:message] << "<hr> This message refers to #{view_context.link_to "#{@product.code} #{@product.name}",
                                                                              product_url(@product)} <hr>"
    end
    @subject = "#{params[:action]} from #{params[:name]} - #{params[:subject]}"
    UserNotifier.send_email(params[:email], @tenant.users.first.email,
                            @subject, params[:message]).deliver_now
    redirect_to root_path, notice: 'Email was sent successfully.'
  end

  def search
    @tenants = TenantSearch.new(params).search
    return flash[:notice] = 'No result for your search' unless @tenants

    @tenants = paginate(@tenants, params[:page]) if @tenants
  end

  private

  def tenant_params
    params.require(:tenant).permit(:tenant_id, :name, :plan, :description, :keywords, category_ids: [])
  end

  def find_tenant
    @tenant = Tenant.find(params[:tenant_id])
  end
end
