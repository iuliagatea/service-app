class ReviewsController < ApplicationController

  def create
    logger.debug 'Creating new review'
    @review = Review.new(tenant_id: params[:tenant], user_id: params[:user], title: params[:title], review: params[:review])
    @review.save
    logger.debug "Created review #{@review.attributes.inspect}"
    redirect_to tenant_path(params[:tenant])
  end
  
  def update
    @review = Review.find(params[:review_id])
    logger.debug "Editing review #{@review.attributes.inspect}"
    @review.title = params[:title]
    @review.review = params[:review]
    @review.save
    redirect_to tenant_path(params[:tenant])
  end
  
  def destroy
    @review = Review.find(params[:id])
    logger.debug "Deleting review #{@review.attributes.inspect}"
    @review.destroy
    respond_to do |format|
      logger.info 'The review was deleted and now the user is going to be redirected...'
      format.html { redirect_to tenant_path(params[:tenant]), notice: 'Review was successfully destroyed.' }
    end
  end
  
end
