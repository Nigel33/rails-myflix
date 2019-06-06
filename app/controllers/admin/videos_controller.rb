class Admin::VideosController < AdminsController
	
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
end 