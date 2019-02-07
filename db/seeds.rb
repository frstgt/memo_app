password = "z8aKm$@3rTEp#+bs"

User.create!(name:  "Example User",
             password:              password,
             password_confirmation: password)

9.times do |n|
  name  = Faker::Name.name
  User.create!(name:  name,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(5)
40.times do
  title = Faker::Lorem.sentence(5)
  description = Faker::Lorem.sentence(40)
  users.each { |user| user.notes.create!(title: title,
                                          description: description) }
end