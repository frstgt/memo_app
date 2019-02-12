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
users.each { |user|

  10.times do
    title = Faker::Book.title
    description = Faker::Lorem.sentence(20)
    user.notes.create!(title: title, description: description)
  end
}

users = User.order(:created_at)
users.each { |user|
  notes = user.notes
  notes.each { |note|

      number = 1
      10.times do
        content = Faker::Lorem.sentence(20)
        note.memos.create!(content: content, number: number)
        number += 1
      end
    }
}
