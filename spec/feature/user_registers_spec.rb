require 'rails_helper'

feature "User registers", {js: true, vcr: true} do 
	background do 
		visit register_path
	end 

	scenario "with declined card and valid user"  do 
		fill_in_valid_user_info
		fill_in_declined_card
		click_button "Register"
		sleep 5

		expect(page).to have_content("Your card was declined.")
	end 

	scenario "with valid user info and valid card" do 
		fill_in_valid_user_info
		fill_in_valid_card
		click_button "Register"
		sleep 5

		expect(page).to have_content("You have registered! Welcome")
	end 

	scenario "with valid user info and invalid card" do 
		fill_in_valid_user_info
		fill_in_invalid_card
		click_button "Register"
		expect(page).to have_content("The card number is not a valid credit card number")
	end 

	scenario "with invalid user info and valid card" do 
		fill_in_invalid_user_info
		fill_in_valid_card
		click_button "Register"
		expect(page).to have_content("Please fix the following errors:")
	end 

	scenario "with invalid user info and invalid card" do 
		fill_in_invalid_user_info
		fill_in_invalid_card
		click_button "Register"
		expect(page).to have_content("The card number is not a valid credit card number")
	end 

	scenario "with invalid user info and declined card" do 
		fill_in_invalid_user_info
		fill_in_declined_card
		click_button "Register"
		expect(page).to have_content("Please fix the following errors:")
	end 

	def fill_in_valid_user_info
		fill_in "Email Address", with: "john@example.com"
		fill_in "Password", with: '12345'
		fill_in "Full name", with: "John Doe"
	end 

	def fill_in_invalid_user_info
		fill_in "Email Address", with: nil
		fill_in "Password", with: '12345'
		fill_in "Full name", with: "John Doe"
	end 

	def fill_in_valid_card
		fill_in "Credit Card Number", with: '4242424242424242'
		fill_in "Security Code", with: '123'
		select "7 - July", from: 'date_month'
		select "2020", from: "date_year"
	end 

	def fill_in_invalid_card
		fill_in "Credit Card Number", with: '123'
		fill_in "Security Code", with: '123'
		select "7 - July", from: 'date_month'
		select "2020", from: "date_year"
	end 

	def fill_in_declined_card 
		fill_in "Credit Card Number", with: '4000000000000002'
		fill_in "Security Code", with: '123'
		select "7 - July", from: 'date_month'
		select "2020", from: "date_year"
	end 
end 