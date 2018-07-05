class EstimatesController < ApplicationController
  before_action :set_estimate, only: [:show, :edit, :update, :destroy]

  # GET /estimates
  # GET /estimates.json
  def index
    @estimates = Estimate.all
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
  end

  # GET /estimates/new
  def new
    @estimate = Estimate.new
  end

  # GET /estimates/1/edit
  def edit
  end

  # POST /estimates
  # POST /estimates.json
  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.value = @estimate.price * @estimate.quantity
    respond_to do |format|
      if @estimate.save
        format.html { redirect_to @estimate, notice: 'Estimate was successfully created.' }
      else
        logger.error "Errors occurred while creating Estimate! #{@estimate.errors}"
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /estimates/1
  # PATCH/PUT /estimates/1.json
  def update
    respond_to do |format|
      @estimate.value = @estimate.price * @estimate.quantity
      if @estimate.update(estimate_params)
        format.html { redirect_to @estimate, notice: 'Estimate was successfully updated.' }
      else
        format.html { render :edit }
        logger.error "Errors occurred while updating Estimate! #{@estimate.errors}"
      end
    end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
   logger.debug "Destroying estimate #{@estimate.attributes.inspect}"
    @estimate.destroy
    respond_to do |format|
      format.html { redirect_to estimates_url, notice: 'Estimate was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def estimate_params
      params.require(:estimate).permit(:name, :quantity, :price, :value, :tenant_id)
    end
end
