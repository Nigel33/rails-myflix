require 'rails_helper'

describe UsersController do 
	describe "GET new" do 
		it "saves @user" do 
			get :new
			expect(assigns(:user)).to be_instance_of(User)
		end 
	end 

	describe "POST create" do 
		context "successful user sign up" do 
			let(:result) { double('register_result', successful?: true) }

			before {
				UserRegister.any_instance.should_receive(:register).and_return(result)
				post :create, user: Fabricate.attributes_for(:user)
			}

			it 'redirects to root if new user is saved' do 
				expect(response).to redirect_to videos_path
			end 
		end 

		context "failed user sign up" do 
			let(:result) { double('register_result', successful?: false, error_message: "Error") }

			before {
				UserRegister.any_instance.should_receive(:register).and_return(result)
				post :create, user: Fabricate.attributes_for(:user)
			}

			it "renders the new template" do 
				expect(response).to render_template :new
			end 

			it "sets the flash error message" do 
				expect(flash[:error]).to be_present
			end 
		end 
	end 

	describe "GET show" do 
		let(:alice) { Fabricate(:user) }

		before do    
			set_current_user
			get :show, id: alice.id
		end 

		it "saves the @user" do 
			expect(assigns(:user)).to eq(alice)
		end 

		it "renders the show template" do 
			expect(response).to render_template(:show)
		end 

		it_behaves_like "requires sign in" do 
			let(:action) { get :show, id: 3}
		end
	end 

	describe "GET new_with_invitation_token" do 
		before do 
			@invitation = Fabricate(:invitation)
		end 

		it 'renders the new view template' do 
			get :new_with_invitation_token, token: @invitation.token
			expect(response).to render_template :new
		end 

		it "sets @user with recipient's email" do 
			get :new_with_invitation_token, token: @invitation.token
			expect(assigns[:user].email).to eq(@invitation.recipient_email)
		end 

		it "sets @invitation_token" do 
			get :new_with_invitation_token, token: @invitation.token
			expect(assigns(:invitation_token)).to eq(@invitation.token)
		end 

		it "redirects to expired token page for invalid tokens" do 
			get :new_with_invitation_token, token: 'random'
			expect(response).to redirect_to expired_token_path
		end 
	end 
end 