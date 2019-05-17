require 'rails_helper'

describe QueueItemsController do 
	let (:alice) { Fabricate(:user) }
	let (:video) { Fabricate(:video) }
	let (:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
	let (:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video) }

	describe "GET index" do 
		before { set_current_user(alice) }
		before { get :index }

		it "sets @queue_items to the queue items of the logged in user" do 
			expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])	
		end 
	
		it_behaves_like "requires sign in" do 
			let(:action) {get :index}
		end 
	end 

	describe "POST create" do 
		before { set_current_user(alice) } 
		before { post :create, video_id: video.id }

		it "redirects ti my_queue page" do 
			expect(response).to redirect_to my_queue_path
		end 

		it "should create a queue item" do 
			expect(QueueItem.count).to eq(1)
		end 

		it "creates the queue item that is associated with the video" do
			expect(QueueItem.first.video).to eq(video)
		end 

	 	it "creates the queue item that is associated with the user" do 
			expect(QueueItem.first.user).to eq(alice)
		end 

		it "puts the video as the last one in the queue" do 
			video2 = Fabricate(:video)
			post :create, video_id: video2.id
			video2_queue_item = QueueItem.find_by({video_id: video2.id, user_id: alice.id })
			expect(video2_queue_item.position).to eq(2)
		end 


		it "does not add the video to the queue if video is already in queue" do 
			post :create, video_id: video.id
			expect(alice.queue_items.count).to eq(1)
		end 

		it_behaves_like "requires sign in" do 
			let(:action) { post :create, video_id: video.id }
		end 
	end 

	describe "DELETE destroy" do 
		before { set_current_user(alice) }

		it "redirect to the my_queue page" do 
			delete :destroy, id: queue_item1.id
			expect(response).to redirect_to(my_queue_path)
		end 

		it "deletes the queue item" do 
			delete :destroy, id: queue_item1.id
			expect(QueueItem.count).to eq(0)
		end 

		it "normalizes the remaining queue items" do 
			queue_item2
			delete :destroy, id: queue_item1.id
			expect(QueueItem.first.position).to eq(1)
		end 

		it "does not delete the queue item if the queue item does not belong to current user" do 
			bob = Fabricate(:user)
			bob_queue_item = Fabricate(:queue_item, position: 1)
			delete :destroy, id: bob_queue_item
			expect(QueueItem.count).to eq(1)
		end 
	
		it_behaves_like "requires sign in" do 
			let(:action) {post :create, video_id: video.id}
		end 

		it "redirects to the sign in page for unauthenticated user" do 
			delete :destroy, id: queue_item1.id
		end 
	end 

	describe "POST update queue" do 
		before { set_current_user(alice) }

		it_behaves_like "requires sign in" do 
			let(:action) do 
				post :update_queue, queue_items: [
						{id: queue_item1.id, position: 2}
					]
			end 
		end 

		context "valid inputs" do 
			it "redirects to the my queue page" do 
				post :update_queue, queue_items: [
					{id: queue_item1.id, position: queue_item1.position},
					{id: queue_item2.id, position: queue_item2.position}
				]
				expect(response).to redirect_to my_queue_path
			end

			it "reorders the queue item" do 
				post :update_queue, queue_items: [
					{id: queue_item1.id, position: 2},
					{id: queue_item2.id, position: 1}
				]
				expect(alice.queue_items).to eq([queue_item2, queue_item1])
			end 

			it "normalizes the position numbers" do 
				post :update_queue, queue_items: [
					{id: queue_item1.id, position: 3},
					{id: queue_item2.id, position: 2}
				]

				expect(alice.queue_items.map(&:position)).to eq([1, 2])
			end
		end  
		
		context "invalid inputs" do 
			before do 
				post :update_queue, queue_items: [
					{id: queue_item1.id, position: 2},
					{id: queue_item2.id, position: 3.4}
				]
			end 

			it "redirects to the my queue page" do 
				expect(response).to redirect_to my_queue_path
			end 

			it "sets the flash error message" do 
				expect(flash[:error]).to be_present
			end 

			it 'does not change the queue item' do 
				expect(queue_item1.reload.position).to eq(1)
			end 
		end 

		context "with queue items that do not belong to current user" do 
			it "should not update queue items thar do not belong to current user" do 
				bob = Fabricate(:user)
				set_current_user(bob)
				queue_item3 = Fabricate(:queue_item, position: 3, user: bob, video: video)
				post :update_queue, queue_items: [
					{id: queue_item1.id, position: 2},
					{id: queue_item3.id, position: 1}
				]
				expect(queue_item1.reload.position).to eq(1)
				expect(queue_item3.reload.position).to eq(1)
			end 
		end 
	end 
end 