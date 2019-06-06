require 'rails_helper'

describe UserRegister do 
	describe "#register" do 
		context "valid personal info and valid card" do 
			let(:customer) { double('customer', successful?: true, customer_token: 'abcdefg') }

			before {
				expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
			}

			it 'saves the @user' do 
				UserRegister.new(Fabricate(:user)).register('123', nil)
				expect(User.count).to eq(1)
			end 

			it 'stores the customer token from Stripe' do 
				UserRegister.new(Fabricate(:user)).register('123', nil)
				expect(User.first.customer_token).to eq('abcdefg')
			end 
		end 

		context "with invitation" do 
			let(:customer) { double('customer', successful?: true, customer_token: 'abcdefg') }

			before do 
				@alice = Fabricate(:user)
				invitation = Fabricate(:invitation, inviter: @alice, recipient_email: "joe@example.com")
				expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
				UserRegister.new(Fabricate(:user, email: 'joe@example.com')).register('123', invitation.token)
			end 

			it "makes the user follow the inviter" do 
				joe = User.find_by({email: 'joe@example.com'})
				expect(joe.follows?(@alice)).to eq(true)
			end 

			it "makes the inviter follow the user" do 
				joe = User.find_by({email: 'joe@example.com'})
				expect(@alice.follows?(joe)).to eq(true)
			end 

			it "expires the invitation upon acceptance" do 
				expect(Invitation.first.token).to eq(nil)
			end 
		end 

		context "valid personal info and declined card" do 
			let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined") }

			before do 
				expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
				UserRegister.new(Fabricate.build(:user, email: 'joe@example.com')).register('123',nil)
			end 

			it "does not create a new user record" do 
				expect(User.count).to eq(0)
			end 
		end 

		context "invalid personal info " do 
			let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined") }

			before do 
				UserRegister.new(Fabricate.build(:user, email: nil)).register('123',nil)
			end

			after { ActionMailer::Base.deliveries.clear }

			it "does not create a user" do 
				expect(User.count).to eq(0)
			end

			it "does not charge the card" do 
				expect(StripeWrapper::Charge).not_to receive(:create)
			end  

			it "does not send out the email with invalid inputs" do 
				expect(ActionMailer::Base.deliveries).to be_empty
			end 
		end  

		context "sending email" do 
			after { ActionMailer::Base.deliveries.clear }
			let(:customer) { double('customer', successful?: true, customer_token: 'abcdefg') }

			before do
				expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
				UserRegister.new(Fabricate.build(:user, email: 'jon@gmail.com', full_name: 'jon doe')).register('123',nil)
			end

			it "sends out email to the user with valid inputs" do 
				expect(ActionMailer::Base.deliveries.last.to).to eq(['jon@gmail.com'])
			end 

			it "sends out email to the user with valid inputs" do 
				expect(ActionMailer::Base.deliveries.last.body).to include('jon')
			end 
		end 
	end 
end 