require 'rails_helper'

describe UsersController do 
	describe "GET new" do 
		it "saves @user" do 
			get :new
			expect(assigns(:user)).to be_instance_of(User)
		end 
	end 

	describe "POST create" do 
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
end 