class Video < ActiveRecord::Base
	belongs_to :category
	has_many :reviews
	has_many :queue_item

	mount_uploader :large_cover, LargeCoverUploader
	mount_uploader :small_cover, SmallCoverUploader

	validates_presence_of :title, :description

	def self.search_by_title(search_term)
		search_term.strip!

		return [] if search_term == '' 
		self.where("title ILIKE ?", "%#{search_term}%").order(created_at: :desc)
	end 
end 