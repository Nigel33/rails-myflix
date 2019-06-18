class Review < ActiveRecord::Base
	include Elasticsearch::Model
	index_name ["myflix", Rails.env].join("_")

	belongs_to :video
	belongs_to :user

	validates_presence_of :rating, :content

	delegate :title, to: :video, prefix: :video
	delegate :full_name, to: :user, prefix: :user
end 