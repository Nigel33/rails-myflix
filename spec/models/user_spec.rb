require 'rails_helper'

describe User do 
	let (:user) { Fabricate(:user) }
	let (:user2) { Fabricate(:user) }
	let (:video) { Fabricate(:video) }


	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:password) }
	it { should validate_presence_of(:full_name) }
	it { should validate_uniqueness_of(:email) }
	it { should have_many(:queue_items) }
 
	it_behaves_like "tokenable" do 
		let(:object) { user }
	end 

	describe "#queued_video?" do 
		it 'returns true when the user queued the video' do 
			queue_item = Fabricate(:queue_item, user: user, video: video, position: 3)
			expect(user.queued_video?(video)).to eq(true)
		end 

		it "returns false when the user hasn't queued the video" do
			expect(user.queued_video?(video)).to eq(false)
		end
	end

	describe "#queue_item_count" do 
		it "returns the number of queued items" do 
			Fabricate(:queue_item, user: user, video: video)
			expect(user.queue_item_count).to eq(1)
		end 
	end  

	describe "#follow?" do 
		it "returns true if user has a following relationship with another user" do 
			Fabricate(:relationship, leader: user2, follower: user)
			expect(user.follows?(user2)).to eq(true)
		end 

		it "returns false if user does not have a following relationship with another user" do 
			expect(user.follows?(user2)).to eq(false)
		end 
	end 

	describe "#follow" do 
		before do 
			@alice = Fabricate(:user)
			@bob = Fabricate(:user)
		end 

		it "follows another user" do 
			@alice.follow(@bob)
			expect(@alice.follows?(@bob)).to eq(true)
		end 

		it "does not follow one self" do 
			@alice.follow(@alice)
			expect(@alice.follows?(@alice)).to eq(false)
		end 
	end 
end 