require 'rails_helper'

describe SessionsController do 
	describe 'GET new' do 
		it "renders the new template if un-authenticated user" do 
			get :new
			expect(response).to render_template :new
		end  

		it "redirects user if authenticated" do 
			session[:user_id] = Fabricate(:user).id
			get :new
			expect(response).to redirect_to videos_path
		end 
	end 

	describe "POST create" do 
		let(:alice) { Fabricate(:user) }
	
		context "with valid credentials" do 
			before { post :create, email: alice.email, password: alice.password }

			it "logs user in" do 
				expect(session[:user_id]).to eq(alice.id)
			end 

			it "redirects user to videos page" do 
				expect(response).to redirect_to videos_path
			end 

			it 'sets the notice' do 
				expect(flash[:notice]).not_to be_blank
			end 
		end 

		context "with invalid credentials" do 
			before { post :create, email: 'wrong', password: 'wrong' }

			it 'does not put the signed in user in the session' do 
				expect(session[:user_id]).to be_nil
			end 

			it 'redirects to login page' do 
				expect(response).to render_template :new
			end 

			it 'sets the error message' do 
				expect(flash[:error]).not_to be_blank
			end 
		end 
	end 

	describe 'GET destroy' do 
		context "logged in user" do 
			before do 
				session[:user_id] = Fabricate(:user).id
				get :destroy
			end 

			it 'clears the session for the user' do 
				expect(session[:user_id]).to be_nil
			end 

			it "redirects to root path" do 
				expect(response).to redirect_to index_path
			end 

			it "sets the notice" do 
				expect(flash[:notice]).not_to be_blank
			end 
		end 
		
	end 
end 