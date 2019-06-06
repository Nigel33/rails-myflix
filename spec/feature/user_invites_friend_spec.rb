require 'rails_helper'

feature "User invites friend" do 
	scenario "User successfully invites friend and invitation is accepted", { js: true, vcr: true} do 
		alice = Fabricate(:user)
		sign_in(alice)

		visit new_invitation_path
		fill_in "Friend's Name", with: "John Doe"
		fill_in "Friend's Email", with: "john@example.com"
		fill_in "Message", with: "Hello please join this site"
		click_button "Send Invitation"
		sign_out

		open_email "john@example.com"
		current_email.click_link "Accept this invitation"

		fill_in "Password", with: "password"
		fill_in "Full name", with: 'John Doe'
		fill_in "Credit Card Number", with: '4242424242424242'
		fill_in "Security Code", with: "123"
		select "7 - July", from: 'date_month'
		select "2020", from: 'date_year' 
		click_button "Register"
		sleep 5

		click_link "People"
		expect(page).to have_content alice.full_name
		sign_out 

		sign_in(alice)
		click_link "People"
		expect(page).to have_content "John Doe"

		clear_email
	end 
end 	