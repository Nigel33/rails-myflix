require 'rails_helper'

describe ForgotPasswordsController do 
	describe "POST Create" do 
		context "With blank inputs" do 
			before { post :create, email: '' }

			it "redirects to the forgot password page" do 
				expect(response).to redirect_to forgot_password_path
			end 

			it "shows an error message" do 
				expect(flash[:error]).to_not be_nil
			end 
		end 

		context "with existing email" do 
			before do   
				@alice = Fabricate(:user, email: 'alice@example.com')
				post :create, email: 'alice@example.com'
			end 

			it "redirect to the forgot password confirmation page" do 
				expect(response).to redirect_to(forgot_password_confirmation_path)
			end 

			it 'sends out an email to the email address' do 
				expect(ActionMailer::Base.deliveries.last.to).to eq(['alice@example.com'])
			end 
		end 

		context "with non-existing email" do
			before { post :create, email: 'foo@example.com' }

			it "redirects to the forgot password page" do 
				expect(response).to redirect_to forgot_password_path
			end 

			it "shows an error message" do 
				expect(flash[:error]).to eq "That email cannot be found"
			end 
		end 
	end 
end 