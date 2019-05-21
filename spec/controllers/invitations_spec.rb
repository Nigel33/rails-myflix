require 'rails_helper'

describe InvitationsController do 
	after { ActionMailer::Base.deliveries.clear }

	describe "GET new" do 
		before { set_current_user }

		it "sets @invitational to a new invitation" do
			get :new 
			expect(assigns(:invitation)).to be_new_record
			expect(assigns(:invitation)).to be_instance_of Invitation
		end 

		it_behaves_like "requires sign in" do 
			let(:action) { get :new }
		end 
	end

	describe "POST create" do 
		before { set_current_user }

		it_behaves_like "requires sign in" do 
			let(:action) { post :create }
		end 

		context "with valid input" do 
			before { post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: 'joe@example.com') }

			it "redirects to the invitation new page" do 
				expect(response).to redirect_to new_invitation_path
			end 

			it "creates an invitation" do 
				expect(Invitation.count).to eq(1)
			end 
			
			it "sends an email to the recipient" do 
				expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
			end 

			it "sets the flash success message" do 
				expect(flash[:notice]).to be_present
			end 
		end 

		context "with invalid input" do 
			before { post :create, invitation: Fabricate.attributes_for(:invitation, recipient_name: nil, recipient_email: 'joe@example.com') }

			it 'renders the new template' do 
				expect(response).to render_template :new
			end

			it "does not create an invitation" do 
				expect(Invitation.count).to eq(0)
			end 

			it 'does not send out an email' do 
				expect(ActionMailer::Base.deliveries).to be_empty
			end 

			it 'sets the flash error message' do 
				expect(flash[:error]).to be_present
			end 

			it 'sets @invitation' do 
				expect(assigns[:invitation]).to be_present
			end 
		end 
	end 
end 