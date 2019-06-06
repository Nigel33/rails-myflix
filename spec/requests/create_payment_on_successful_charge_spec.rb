require 'rails_helper'

describe "CreatePaymentOnSuccessfulCharge" do 
	let(:alice) { Fabricate(:user, customer_token: 'cus_FBei0JR8TP41m4') }

	def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:event_data) { File.read("spec/support/fixtures/charge_created.json") }
  before do 
  	bypass_event_signature(event_data) 
  end

	it "creates a payment with the webhook from stripe for charge succeeeded" do
		post "/stripe_events", event_data 
		expect(Payment.count).to eq(1)
	end 

	it "creates the payment associated with user" do 
		alice
		post "/stripe_events", event_data 
		expect(Payment.first.user).to eq(alice)
	end 

	it "creates the payment with the amount" do 
		alice 
		post "/stripe_events", event_data 
		expect(Payment.first.amount).to eq(999)
	end 

	it "creates the payment with reference id" do 
		alice 
		post "/stripe_events", event_data 
		expect(Payment.first.reference_id).to eq('ch_1EhHPPDbHuZc0afKM3uQZ5ox')
	end 
end 