class RelationshipsController < ApplicationController 
	before_filter :require_user

	def index 
		@relationships = current_user.following_relationships
	end 	

	def destroy 
		relationship = Relationship.find(params[:id])
		if relationship.follower == current_user
			relationship.destroy
		end 
		redirect_to people_path
	end 

	def create
		leader = User.find(params[:leader_id])

		if current_user.can_follow?(leader)
			relationship = Relationship.create(leader_id: params[:leader_id], follower: current_user) 
		end 
		
		redirect_to people_path
	end 
end 