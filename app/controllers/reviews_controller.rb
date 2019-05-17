class ReviewsController < ApplicationController 
	before_filter :require_user
	before_action :set_post

	def create
		@review = @video.reviews.build(review_params)
		@review.user = current_user
		@reviews = @video.reviews
		
		if @review.save
			flash[:notice] = "Review has been left"
			redirect_to video_path(@review.video)
		else 
			flash[:error] = "Please fix errors"
			render :template => "videos/show"
		end  
	end 

	private 

	def review_params 
		params.require(:review).permit!
	end 

	def set_post 
		@video = Video.find(params[:video_id])
	end 
end 