require 'rails_helper'

describe Review do 
	let (:user) { Fabricate(:user) }
	let (:video) { Fabricate(:video) }
	let (:review) {Fabricate(:review, video: video, user: user) }

	it { should belong_to(:user) }
	it { should belong_to(:video) }

	describe "#video_title" do 
		it "should return the title of the video" do 
			expect(review.video_title).to eq(video.title)
		end 
	end 

	describe "#user.name" do 
		it "should return the name of the user" do 
			expect(review.user_full_name).to eq(user.full_name)
		end 
	end 
end 