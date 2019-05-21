require 'rails_helper'

feature "User rests his password" do 
	given(:alice) { Fabricate(:user, password: 'password') } 

	scenario "user successfully resets his password" do 
		visit login_path
		click_link "Forgot Password"
		fill_in "Email Address", with: alice.email
		click_button "Send Email"

		open_email(alice.email)
		current_email.click_link("Reset My Password")

		fill_in "New Password", with: 'new_password'
		click_button "Reset Password"

		fill_in "Email Address", with: alice.email
		fill_in "Password", with: 'new_password'
		click_button "Login"
		expect(page).to have_content("Welcome, #{alice.full_name}")

		clear_email
	end 
end 