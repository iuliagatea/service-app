# frozen_string_literal: true

class StatusesController < ApplicationController
  before_action :set_status, only: %i[show edit update destroy]
  before_action :set_current_tenant, only: %i[show edit update destroy new create]
  before_action :verify_tenant
  before_action :verify_user, except: [:products]

  def index
    logger.debug "Showing statuses for #{current_user.email}"
    @statuses = Status.by_tenant(params[:tenant_id]).paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def new
    logger.debug "New status for user #{current_user.email}"
    @status = Status.new
  end

  def edit; end

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

  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to tenant_statuses_url, notice: 'Status was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to tenant_statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def products
    @user = current_user
    @status = Status.find(params[:status_id])
    if @user.is_admin
      logger.debug "Showing products with statuses for tenant #{current_user.email}"
      @products = @status.products_with_status.paginate(page: params[:page], per_page: 10)
    else
      logger.debug "Showing products with statuses for user #{current_user.email}"
      @products = @status.products_with_status_by_user(@user).paginate(page: params[:page], per_page: 10)
    end
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:name, :color, :tenant_id, :is_active)
  end
end
