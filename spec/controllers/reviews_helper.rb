require 'rails_helper'

describe ReviewsController do 
	describe "POST create" do 
		context "authenticated user" do 
			it "saves @review" do 

			end 

			it "redirects to the show video path" do 

			end

			it "leaves flash notice upon submission" do 

			end 
		end 
		
		context "un-authenticated user" do 
			it "does not save the @review" do 

			end 

			it "rerenders the show video path" do 

			end 

			it "leaves flash error" do 

			end 
		end 
	end 
end 