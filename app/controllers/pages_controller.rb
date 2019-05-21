class PagesController < ApplicationController 
	def index 
		redirect_to videos_path if logged_in?
	end 

	def expired_token
	end 
end 