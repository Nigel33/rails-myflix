require 'rails_helper'

describe StripeWrapper do 
	describe StripeWrapper::Charge do 
		let(:token) { 'tok_visa' }
		let(:declined_token) { 'tok_chargeDeclined' }
		context "valid charge" do 
			before do 
				StripeWrapper.set_api_key
			end 

			it ".create", :vcr do 
				response = StripeWrapper::Charge.create(
					amount: 999,
					source: token, 
					description: 'just for kicks'
				)

				expect(response.successful?).to eq(true)
			end 
		end 

		context "invalid charge" do 
			let(:response) do 
				StripeWrapper::Charge.create(
					amount: 999,
					source: declined_token, 
					description: 'just for kicks'
				)
			end 

			it "makes a card declined charge", :vcr do 
				expect(response).not_to be_successful
			end 

			it "returns the error message for declined charges", :vcr do 
				expect(response.error_message).to eq("Your card was declined.")
			end 
		end 
	end 

	describe StripeWrapper::Customer do 
		describe ".create", :vcr do 
			let(:alice) { Fabricate(:user) }
			let(:token) { 'tok_visa' }
			let(:declined_token) { 'tok_chargeDeclined' }

			it "creates a customer with valid card" do 
				response = StripeWrapper::Customer.create(
					user: alice,
					card: token, 
				)

				expect(response.customer_token).to be_present
			end 

			it "returns the customer token for a valid card" do 
				response = StripeWrapper::Customer.create(
					user: alice,
					card: token, 
				)


			end 

			it "does not create a customer with declined card" do 
				response = StripeWrapper::Customer.create(
					user: alice,
					card: 'tok_chargeDeclined', 
				)

				expect(response.successful?).to eq(false)
			end 

			it "displays error message with declined card" do 
				response = StripeWrapper::Customer.create(
					user: alice,
					card: 'tok_chargeDeclined', 
				)

				expect(response.error_message).to eq('Your card was declined.')
			end 
		end 

	end 
end 