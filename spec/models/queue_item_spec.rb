require 'rails_helper'

describe QueueItem do 
	let (:category) { Fabricate(:category, name: "Comedy") }
	let (:video) { Fabricate(:video, title: "Monk", category: category) }
	let (:alice) { Fabricate(:user) }
	let (:review) { Fabricate(:review, video: video, user: alice, rating: 4) }
	let (:queue_item) { Fabricate(:queue_item, video: video, user: alice, position: 1) }

	it { should belong_to(:user) }
	it { should belong_to(:video) }
	it { should validate_numericality_of(:position) }

	describe "#video_title" do 
		it "returns the title of the associated video" do 
			expect(queue_item.video_title).to eq("Monk")
		end 
	end 

	describe "#rating" do 
		it "returns the rating from the review if present" do 
			review #lazy eval
			expect(queue_item.rating).to eq(4)
		end 

		it "returns nil if review is not present" do 
			expect(queue_item.rating).to eq(nil)
		end 
	end 

	describe "#rating=" do 
		it "changes the rating of a review if rating present" do 
			review #lazy eval
			queue_item.rating = 1
			expect(Review.first.rating).to eq(1)
		end 

		it "clears the rating of a review if present" do 
			review #lazy eval
			queue_item.rating = nil 
			expect(Review.first.rating).to eq(nil)
		end 

		it "creates a review with the rating if the review is not present" do
			queue_item.rating = 1
			expect(Review.first.rating).to eq(1)
		end 
	end 

	describe "#category_name" do 
		it "returns the category's name of the video" do
			expect(queue_item.category_name).to eq("Comedy") 
		end 
	end 

	describe "#category" do 
		it "returns the category of the video" do
			expect(queue_item.category).to eq(category)
		end
	end 
end 