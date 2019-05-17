require 'rails_helper'

describe ReviewsController do 
	describe "POST create" do 
		let (:video) { Fabricate(:video) }
		let (:user) { Fabricate(:user) }
	
		context "authenticated user and success" do 
			before { session[:user_id] = user.id }
			before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
			it "saves @review" do 
				expect(assigns(:review)).to_not be_nil
			end 

			it "redirects to the show video path" do 
				expect(response).to redirect_to video_path(video)
			end

			it "leaves flash notice upon submission" do 
				expect(flash[:notice]).to_not be_nil
			end 

			it 'creates a review associated with the video' do 
				expect(assigns(:review).user).to eq(user)
			end 

			it 'creates a review assoicated with the user' do 
				expect(assigns(:review).video).to eq(video)
			end 
		end

		context "authenticated user and failure" do 
			before { session[:user_id] = user.id }
			before { post :create, review: Fabricate.attributes_for(:review) { content '' }, video_id: video.id }

			it "does not save the @review" do 
				expect(Review.count).to eq(0)
			end 

			it "rerenders the show video template" do 
				expect(response).to render_template("videos/show")
			end 
		end 
		
		context "un-authenticated user" do
			before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }

			it "does not save the @review" do 
				expect(assigns(:review)).to be_nil
			end 

			it "redirects to root path" do 
				expect(response).to redirect_to(login_path)
			end 

			it "leaves flash error" do 
				expect(flash[:error]).to_not be_nil
			end 
		end 
	end 
end 