class UsersController < ApplicationController 
	before_filter :require_user, only: [:show]

	def new
		@user = User.new
	end 

	def create 
		@user = User.new(user_params)
		result = UserRegister.new(@user).register(params[:stripeToken], params[:invitation_token])

		if result.successful? 		
			flash[:notice] = "You have registered! Welcome"
			session[:user_id] = @user.id
			redirect_to videos_path
		else 
			flash[:error] = result.error_message 
			render :new
		end 
	end 

	def show 
		@user = User.find(params[:id])
	end 

	def new_with_invitation_token 
		invitation = Invitation.find_by({token: params[:token]})
		if invitation
			@user = User.new(email: invitation.recipient_email)
			@invitation_token = invitation.token
			render :new
		else 
			redirect_to expired_token_path
		end 
	end 

	private 

	def user_params 
		params.require(:user).permit(:email, :full_name, :password)
	end  
end 