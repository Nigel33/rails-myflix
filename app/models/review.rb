class Review < ActiveRecord::Base
	belongs_to :video
	belongs_to :user

	validates_presence_of :rating, :content

	delegate :title, to: :video, prefix: :video
	delegate :full_name, to: :user, prefix: :user
end 