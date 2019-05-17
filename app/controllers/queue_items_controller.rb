class QueueItemsController < ApplicationController 
	before_filter :require_user

	def index 
		@queue_items = current_user.queue_items
	end 

	def create 
		video = Video.find(params[:video_id])
		video_present = current_user.queue_items.find_by({ user_id: current_user.id, video_id: video.id })
		
		if !(video_present)
			QueueItem.create(video: video, user: current_user, position: current_user.queue_items.count + 1)
		end

		redirect_to my_queue_path
	end 

	def destroy 
		queue_item = QueueItem.find(params[:id])

		if (queue_item.user == current_user)
			queue_item.destroy
		end
		
		current_user.normalize_queue_item_position
		redirect_to my_queue_path
	end 

	def update_queue
		begin
			update_queue_items
			current_user.normalize_queue_item_position
		rescue ActiveRecord::RecordInvalid
			flash[:error] = "Invalid position numbers."
		end

		redirect_to my_queue_path
	end 

	private 

	def update_queue_items
		ActiveRecord::Base.transaction do 
			params[:queue_items].each do |queue_item_data|
				queue_item = QueueItem.find(queue_item_data['id'])
				if queue_item.user == current_user
					queue_item.update_attributes!(position: queue_item_data['position'], rating: queue_item_data["rating"])
				end
			end
		end  
	end 
end 