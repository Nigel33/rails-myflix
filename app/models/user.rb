class User < ActiveRecord::Base 
	has_many :reviews, -> { order('created_at DESC') }
	has_many :queue_items, -> { order('position') }
	has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id 
	has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

	validates_presence_of :full_name, :email, :password
	has_secure_password validations: false
	validates_uniqueness_of :email

	def normalize_queue_item_position 
		queue_items.each_with_index do |queue_item, idx|
			queue_item.update_attributes(position: idx + 1)
		end 
	end

	def queued_video?(video)
		queue_items.map(&:video).include?(video)
	end  

	def queue_item_count
		queue_items.count
	end 

	def follows?(other_user)
		following_relationships.map(&:leader).include?(other_user)
	end 

	def can_follow?(other_user)
		!self.follows?(other_user) && self != other_user
	end 
end 