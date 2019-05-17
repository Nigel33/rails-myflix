Fabricator(:video) do 
	title { Faker::Name.name }
	description { Faker::Lorem.words(5).join(' ')}
	created_at { Faker::Date.between(5.days.ago, 3.days.ago) }
	updated_at { Faker::Date.between(2.days.ago, Date.today) }
end 