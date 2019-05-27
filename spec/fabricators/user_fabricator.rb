Fabricator(:user) do 
	email { Faker::Internet.email }
	password { Faker::Food.dish }
	full_name { Faker::Name.name }
	admin false
end 

Fabricator(:admin, from: :user) do 
	admin true
end 