

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



