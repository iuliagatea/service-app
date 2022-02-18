# frozen_string_literal: true

class ReviewsController < ApplicationController
  def create
    logger.debug 'Creating new review'
    @review = Review.new(review_params)
    @review.save
    logger.debug "Created review #{@review.attributes.inspect}"
    redirect_to tenant_path(params[:tenant_id])
  end

  def update
    @review = Review.find(params[:review_id])
    logger.debug "Editing review #{@review.attributes.inspect}"
    @review.title = params[:title]
    @review.review = params[:review]
    @review.save
    redirect_to tenant_path(params[:tenant_id])
  end

  def destroy
    @review = Review.find(params[:id])
    logger.debug "Deleting review #{@review.attributes.inspect}"
    @review.destroy
    respond_to do |format|
      logger.info 'The review was deleted and now the user is going to be redirected...'
      format.html { redirect_to tenant_path(params[:tenant_id]), notice: 'Review was successfully destroyed.' }
    end
  end

  private

  def review_params
    params.require(:review).permit(:tenant_id, :user_id, :title_review, :review)
  end
end
