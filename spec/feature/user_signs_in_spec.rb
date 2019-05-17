require 'rails_helper'

feature "User signs in" do 
	given(:alice) { Fabricate(:user) }

	scenario "with existing username" do 
		sign_in(alice)
		expect(page).to have_content(alice.full_name)
	end 
end 