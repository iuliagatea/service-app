# frozen_string_literal: true

class ProductStatusesController < ApplicationController
  before_action :set_product_status, only: %i[show edit update destroy]

  def index
    @product_statuses = ProductStatus.all
  end

  def show; end

  def new
    @product_status = ProductStatus.new
  end

  def create
    @product_status = ProductStatus.new(product_status_params)

    respond_to do |format|
      if @product_status.save
        format.html { redirect_to @product_status, notice: 'Product status was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @product_status.update(product_status_params)
        format.html { redirect_to @product_status, notice: 'Product status was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @product_status.destroy
    respond_to do |format|
      format.html do
        redirect_to tenant_product_statuses_url(tenant_id: params[:tenant_id]),
                    notice: 'Product status was successfully destroyed.'
      end
    end
  end

  private

  def set_product_status
    @product_status = ProductStatus.find(params[:id])
  end

  def product_status_params
    params.require(:product_status).permit(:product_id, :status_id)
  end
end
