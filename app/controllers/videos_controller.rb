class VideosController < ApplicationController
	before_action :set_video, only: [:show, :edit, :update]
	before_action :require_user

	def index
		@categories = Category.all
	end

	def show
		@review = Review.new
		@reviews = @video.reviews

	end 

	def display
		@results = Video.search_by_title(params[:search])
	end 

	private 

	def set_video 
		@video = Video.find(params[:id])
	end 
end 