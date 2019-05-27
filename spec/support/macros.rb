

def set_current_user(user=nil)
	session[:user_id] = (user || Fabricate(:user).id)
end 

def set_current_admin(admin=nil)
	session[:user_id] = (admin || Fabricate(:admin).id)
end 

def sign_in(a_user=nil)
	user = a_user || Fabricate(:user)
	visit login_path
	fill_in "email", with: user.email
	fill_in "password", with: user.password
	click_button 'Login'
end
 
def add_video_to_queue(video)
	visit videos_path
	click_on_video_on_home_page(video)
	click_link "+ My Queue"
end 

def set_video_position(video, position)
	find("input[data-video-id='#{video.id}']").set(position)
end

def expect_video_position(video, position)
	expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
end

def click_on_video_on_home_page(video)
	find("a[href='/videos/#{video.id}']").click
end 

def unfollow(user)
	find("a[data-method='delete']").click
end 

def sign_out 
	visit logout_path
end 


module StripeWrapper
	class Charge 
		attr_reader :response, :success

		def initialize(response, status) 
			@response = response
			@success = success
		end 

		def self.create(options={})
			StripeWrapper::set_api_key

			begin 
				response = Stripe::Charge.create(
					amount: options[:amount],
					currency: 'usd'
				)
				new(response, :success)
			rescue Stripe::CardError => expect_video_position
				new(e, :error)
			end 
		end 

		def successful? 
			status == :success
		end

		def error_message
			response.message
		end  
	end 

	def self.set_api_key 
		Stripe.api_key = Rails.env.production? ? ENV['STRIPE_LIVE_API_KEY'] : ENV["STRIPE_SECRET_KEY"]
	end 
end 
