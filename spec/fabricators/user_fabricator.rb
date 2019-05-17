Fabricator(:user) do 
	email { Faker::Internet.email }
	password { Faker::Food.dish }
	full_name { Faker::Name.name }
end 