class Admin::VideosController < ApplicationController 
	before_filter :require_user
	before_filter :require_admin

	def new 
		@video = Video.new
	end 

	def create 
		@video = Video.new(video_params)

		if @video.save 
			redirect_to new_admin_video_path
			flash[:notice] = "You have successfully added #{@video}"
		else 
			render :new
			flash[:error] = "Please check your inputs"
		end 
	end 

	private 

	def video_params 
		params.require(:video).permit!
	end 

	def require_admin
		if !current_user.admin?
			flash[:error] = "You are not authorized to do that"
			redirect_to videos_path
		end 
	end 
end 