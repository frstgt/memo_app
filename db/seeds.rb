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

# pen names
users = User.order(:created_at)
users.each { |user|

  2.times do
    name = Faker::Name.name
    description = Faker::Lorem.sentence(20)
    user.pen_names.create!(name: name, description: description)
  end
}

# notes
users = User.order(:created_at)
users.each { |user|
  pen_names = user.pen_names
  pen_names.each { |pen_name|

    2.times do
      title = Faker::Book.title
      description = Faker::Lorem.sentence(20)
      user.notes.create!(title: title, description: description, pen_name_id: pen_name.id)
    end
  }
}

# memos
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


