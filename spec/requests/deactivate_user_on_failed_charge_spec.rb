require 'rails_helper'

describe "Deactivate User On Failed Charge" do 
	def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:event_data) { File.read("spec/support/fixtures/charge_failed.json") }
  before do 
  	bypass_event_signature(event_data) 
  end

  

  it "deactivates a user with the web hook data from stripe for charge failed" do 
  	alice = Fabricate(:user, customer_token: 'cus_FC2cOEr4RLYBYB')
  	post "/stripe_events", event_data
  	expect(alice.reload).not_to be_active
  end 
end 

	