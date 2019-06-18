class Video < ActiveRecord::Base
	include Elasticsearch::Model
	

	belongs_to :category
	has_many :reviews
	has_many :queue_item

	mount_uploader :large_cover, LargeCoverUploader
	mount_uploader :small_cover, SmallCoverUploader

	validates_presence_of :title, :description

	mapping do
    indexes :name, type: 'text' do
      indexes :search, type: 'completion'
    end
  
    indexes :title, type: 'text'
    indexes :description, type: 'text'
   
  end

	def self.search_by_title(search_term)
		search_term.strip!

		return [] if search_term == '' 
		self.where("title ILIKE ?", "%#{search_term}%").order(created_at: :desc)
	end 

	def rating 
		(reviews.map(&:rating).reduce(&:+) / reviews.length).round(1) unless reviews.empty?
	end 
end 