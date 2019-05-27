shared_examples "requires sign in" do 
	it "redirects to the sign in page" do 
		session[:user_id] = nil
		action
		expect(response).to redirect_to login_path
	end 
end 

shared_examples "tokenable" do 
	it "generates a random token when the user is created" do 
		expect(object.token).to_not be_nil
	end
end 

shared_examples "requires admin" do 
	it "redirects to the videos path" do 
		session[:user_id] = Fabricate(:user).id 
		action
		expect(response).to redirect_to videos_path
	end 
end 