require 'rails_helper'

describe Admin::VideosController do 
	describe "GET new" do 
		context "authenticated admin" do 
			before do 
				set_current_admin
				get :new
			end 

			it_behaves_like "requires sign in" do 
				let(:action) { get :new }
			end 

			it "sets the @video to a new video" do 
				expect(assigns[:video]).to be_instance_of Video 
				expect(assigns[:video]).to be_new_record
			end 
		end 

		context "authenticated regular user" do 
			before do 
				set_current_user
				get :new
			end 

			it_behaves_like "requires sign in" do
				let(:action) { get :new }
			end 

			it 'sets the flash error message for regular user' do 
				expect(flash[:error]).to be_present
			end 
		end
	end 

	describe "POST create" do  
		it_behaves_like "requires sign in" do
			let(:action) { post :create }
		end

		it_behaves_like "requires admin" do 
			let(:action) {post :create }
		end

		context "with valid input" do 
			before do 
				set_current_admin
				@category = Fabricate(:category)
				post :create, video: Fabricate.attributes_for(:video, category: @category)
			end 

			it "redirect to add new video page" do 
				expect(response).to redirect_to new_admin_video_path
			end 

			it "creates a video" do 
				expect(@category.videos.count).to eq(1)
			end 

			it "sets the flash message" do 
				expect(flash[:notice]).to be_present
			end 
		end 

		context "with invalid input" do 
			before do 
				set_current_admin
				post :create, video: Fabricate.attributes_for(:video, title: nil)
			end 

			it "does not create a video" do 
				expect(Video.count).to eq(0)
			end 

			it "renders the :new template" do 
				expect(response).to render_template :new
			end 

			it "sets the @video variable" do 
				expect(assigns(:video)).to be_present
			end 

			it "sets the flash error message" do 
				expect(flash[:error]).to be_present
			end 
		end
	end 
end 

	

 