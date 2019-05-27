# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(name: 'Comedy')
thriller = Category.create(name: 'Thriller')
rom_com = Category.create(name: 'Romantic Comedy')

# 8.times do |n| 
# 	Video.create(title: "Family Guy #{n + 1}", description: 'anything goes', category: comedy, small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")
# end 

# 3.times do |n| 
# 	Video.create(title: "Excelsior #{n + 1}", description: 'anything goes', category: thriller, small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
# end

monk = Video.create(title: "Monkeying around", description: 'bla bla', category: rom_com) 

nigel = User.create(full_name: "Nigel Hing", password: "password", email: "nigelhing1@example.com", admin: true)

# Review.create(user: nigel, video: monk, rating: 3, content: "This is a really interesting movie!")
# Review.create(user: nigel, video: monk, rating: 5, content: "This is a really interesting movie!")