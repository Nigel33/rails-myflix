require 'rails_helper'

describe VideosController do 
	let (:movie1) do 
		Fabricate(:video, title: 'Family Guy')
	end 
	let (:review1) { Fabricate(:review, video: movie1) }
	let (:review2) { Fabricate(:review, video: movie1) }
	 
		context "authenticated user" do
			before { session[:user_id] = Fabricate(:user).id }
			
			context "GET show" do 
				before { get :show, id: movie1.id }

				it "sets @video" do
					expect(assigns(:video)).to eq(movie1)
				end 

				it 'sets @reviews' do 
					expect(assigns(:reviews)).to match_array([review1, review2])
				end 
			end

			context "GET display" do 
				before { get :display, search: 'family' }

				it 'sets @results' do 
					expect(assigns(:results)).to eq([movie1])
				end
			end  
		end

		context "un-authenticated_user" do

			context "GET show" do 
				before { get :show, id: movie1.id }

				it "redirects user to sign in page" do
					expect(response).to redirect_to login_path
				end 	
			end 

			context "GET display" do
				before { get :display, search: 'family' }

				it "redirects user to sign in page" do
					expect(response).to redirect_to login_path
				end 	
			end 
		end 

end 