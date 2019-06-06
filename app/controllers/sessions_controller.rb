class SessionsController < ApplicationController 
	
	def new 
		redirect_to videos_path if logged_in?
	end 

	def create
		user = User.find_by(email: params[:email])
		if (user && user.authenticate(params[:password]))
			if user.active
				session[:user_id] = user.id
				flash[:notice] = "You've successfully logged in"
				redirect_to videos_path
			else 
				flash[:error] = "Your account is no longer active. Please contact customer service"
				render :new
			end 
		else 
			flash[:error] = "Something is wrong with your email or password"
			render :new
		end 
	end 

	def destroy 
		session[:user_id] = nil
		flash['notice'] = "You've logged out"
		redirect_to index_path
	end 
end 