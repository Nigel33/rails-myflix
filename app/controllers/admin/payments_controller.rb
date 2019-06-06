class Admin::PaymentsController < ApplicationController 
	before_filter :require_user
	before_filter :require_admin

	def require_admin
		if !current_user.admin?
			flash[:error] = "You are not authorized to do that"
			redirect_to videos_path
		end 
	end 
	
	def index 
		@payments = Payment.all
	end 
end 