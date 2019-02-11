password = "z8aKm$@3rTEp#+bs"

User.create!(name:  "Example User",
             password:              password,
             password_confirmation: password)

2.times do |n|
  name  = Faker::Name.name
  User.create!(name:  name,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at)
10.times do
  title = Faker::Book.title
  description = Faker::Lorem.sentence(20)
  users.each { |user| user.notes.create!(title: title,
                                          description: description) }
end

notes = Note.order(:created_at)
10.times do
  content = Faker::Lorem.sentence(20)
  notes.each { |note| note.memos.create!(type: TextMemo, content: content, user: note.user) }
#  picture = 
#  notes.each { |note| note.memos.create!(type: ImageMemo, picture: picture) }
end