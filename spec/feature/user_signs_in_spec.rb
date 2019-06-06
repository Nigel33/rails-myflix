require 'rails_helper'

feature "User signs in" do 
	given(:alice) { Fabricate(:user) }

	scenario "with existing username" do 
		sign_in(alice)
		expect(page).to have_content(alice.full_name)
	end 

	scenario "With deactivated user" do 
		bob = Fabricate(:user, active: false)
		sign_in(bob)
		expect(page).to have_content("Your account is no longer active. Please contact customer service")
	end 
end 