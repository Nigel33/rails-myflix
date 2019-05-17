require 'rails_helper'

describe RelationshipsController do 
	let (:alice) { Fabricate(:user) }
	let (:bob) { Fabricate(:user) }
	
	before do 
		set_current_user(alice)
	end 

	describe 'GET index' do 
		it "sets @relationships to the current user's following relationships" do 
			relationship = Fabricate(:relationship, follower: alice, leader: bob)
			get :index
			expect(assigns(:relationships)).to eq([relationship])
		end

		it_behaves_like 'requires sign in' do 
			let(:action) {get :index}
		end 
	end 

	describe 'DELETE destroy' do 
		before do 
			set_current_user(alice)
		end 

		it_behaves_like "requires sign in" do 
			let(:action) { delete :destroy, id: 4 }
		end 

		it 'redirects to the people page' do 
			relationship = Fabricate(:relationship, follower: alice, leader: bob)
			delete :destroy, id: relationship.id
			expect(response).to redirect_to people_path
		end 

		it 'deletes the relationship if the current_user is the follower' do 
			relationship = Fabricate(:relationship, follower: alice, leader: bob)
			delete :destroy, id: relationship.id
			expect(Relationship.count).to eq(0)
		end 

		it "does not delete the relationship if the current user is not the follower" do 
			charlie = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: charlie, leader: bob)
			delete :destroy, id: relationship.id
			expect(Relationship.count).to eq(1)
		end 
	end 

	describe "POST create" do 
		it_behaves_like "requires sign in" do 
			let (:action) { post :create, leader_id: 3}
		end 

		it "redirects to the people page" do 
			post :create, leader_id: bob.id
			expect(response).to redirect_to people_path
		end 

		it "creates a Relationship that the current user dollows the leader" do 
			post :create, leader_id: bob.id
			expect(alice.following_relationships.first.leader).to eq(bob)
		end 

		it "does not create a relationship if the current user already follows the leader" do 
			Fabricate(:relationship, follower: alice, leader: bob)
			post :create, leader_id: bob.id 
			expect(Relationship.count).to eq(1)
		end 

		it "does not allow one to follow themselves" do 
			post :create, leader_id: alice.id
			expect(Relationship.count).to eq(0)
		end 
	end 
end 

