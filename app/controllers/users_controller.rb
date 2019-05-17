class UsersController < ApplicationController 
	before_filter :require_user, only: [:show]

	def new
		@user = User.new
	end 

	def create 
		@user = User.new(user_params)
		
		if @user.save 
			AppMailer.send_welcome_email(@user).deliver
			flash[:notice] = "You have registered! Welcome"
			session[:user_id] = @user.id
			redirect_to videos_path
		else 
			flash[:error] = 'Please fix the following errors'
			render :new
		end 
	end 

	def show 
		@user = User.find(params[:id])
	end 

	private 

	def user_params 
		params.require(:user).permit(:email, :full_name, :password)
	end 
end 