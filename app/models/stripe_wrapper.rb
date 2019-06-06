module StripeWrapper 
	class Charge
		attr_reader :response, :error_message

		def initialize(options={})
			@response = options[:response]
			@error_message = options[:error_message]
		end 

		def self.create(options={})
			StripeWrapper.set_api_key

			begin 
				response = Stripe::Charge.create(
					amount: options[:amount],
					currency: 'usd',
					description: options['description'],
					card: options[:source]
				)

				new(response: response)
			rescue Stripe::CardError => e 
				new(error_message: e.message)
			end 
		end 

		def successful? 
			response.present?
		end 
	end

	class Customer 
		attr_reader :customer, :error_message

		def initialize(options={})
			@customer = options[:customer]
			@error_message = options[:error_message]
		end 

		def self.create(options={}) 
			StripeWrapper.set_api_key

			customer = Stripe::Customer.create(
				card: options[:card],
				email: options[:user].email,
				plan: 'base'
			).id

			if charge_successful?(customer)
				new(customer: customer)
			else 
				new(error_message: process_error(customer))
			end 
		end 

		def self.charge_successful?(client)
			Stripe::Charge.list(customer: client)[:data][0][:status] == "succeeded"
		end 

		def self.process_error(client)
			Stripe::Customer.delay.delete(client)
			Stripe::Charge.list(customer: client)[:data][0][:failure_message]
		end 

		def successful? 
			customer.present?
		end 	

		def customer_token 
			customer
		end 
	end 

	def self.set_api_key 
		Stripe.api_key = ENV['STRIPE_SECRET_KEY']
	end  
end 