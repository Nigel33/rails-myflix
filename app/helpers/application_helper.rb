module ApplicationHelper
	def options_for_video_review(selected=nil)
		options_for_select([['5 stars', 5], ['4 stars', 4], ['3 stars', 3], ['2 stars', 2], ['1 star', 1]], selected)
	end 
end
