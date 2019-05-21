require 'rails_helper'

describe UsersController do 
	describe "GET new" do 
		it "saves @user" do 
			get :new
			expect(assigns(:user)).to be_instance_of(User)
		end 
	end 

	describe "POST create" do 
		context "valid input" do 
			it 'saves the @user' do 
				post :create, user: Fabricate.attributes_for(:user)
				expect(User.count).to eq(1)
			end 

			it 'redirects to root if new user is saved' do 
				post :create, user: Fabricate.attributes_for(:user)
				expect(assigns[:user].save).to eq(true)
				expect(response).to redirect_to videos_path
			end 

			it 're-renders new template if there is error' do 
				post :create, user: { full_name: '', password: 'password', email: 'jon@gmail.com' }
				expect(assigns[:user].save).to eq(false)
				expect(response).to render_template
			end

			context "with invitation" do 
				before do 
					@alice = Fabricate(:user)
					invitation = Fabricate(:invitation, inviter: @alice, recipient_email: "joe@example.com")
					post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe' }, invitation_token: invitation.token
				end 

				it "makes the user follow the inviter" do 
					joe = User.find_by({email: 'joe@example.com'})
					expect(joe.follows?(@alice)).to eq(true)
				end 

				it "makes the inviter follow the user" do 
					joe = User.find_by({email: 'joe@example.com'})
					expect(@alice.follows?(joe)).to eq(true)
				end 

				it "expires the invitation upon acceptance" do 
					expect(Invitation.first.token).to eq(nil)
				end 
			end 
		end 

		context "invalid input" do 
			it "does not create a user" do 
				post :create, user: { email: 'jon@example.com'}
				expect(User.count).to eq(0)
			end

			it "renders the :new template" do 
				post :create, user: { email: 'jon@example.com'}
				expect(response).to render_template :new
			end  
		end  

		context "sending email" do 
			after { ActionMailer::Base.deliveries.clear }

			it "sends out email to the user with valid inputs" do 
				post :create, user: { full_name: 'jon', password: 'password', email: 'jon@gmail.com' }
				expect(ActionMailer::Base.deliveries.last.to).to eq(['jon@gmail.com'])
			end 

			it "sends out email to the user with valid inputs" do 
				post :create, user: { full_name: 'jon', password: 'password', email: 'jon@gmail.com' }
				expect(ActionMailer::Base.deliveries.last.body).to include('jon')
			end 

			it "does not send out the email with invalid inputs" do 
				post :create, user: { full_name: 'jon' }
				expect(ActionMailer::Base.deliveries).to be_empty
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