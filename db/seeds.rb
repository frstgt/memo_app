password = "z8aKm$@3rTEp#+bs"

User.create!(name:  "Example User",
             password:              password,
             password_confirmation: password)
4.times do |n|
  name  = Faker::Name.name
  User.create!(name:  name,
               password:              password,
               password_confirmation: password)
end

# groups
name  = Faker::Team.name
description = Faker::Lorem.sentence(20)
Group.create!(name: name, description: description)

# pen names
users = User.order(:created_at)
users.each { |user|

  2.times do
    name = Faker::Name.name
    description = Faker::Lorem.sentence(20)
    user.pen_names.create!(name: name, description: description)
  end
}

# memberships
users = User.order(:created_at)
group = Group.first
members = []
for user in users do
  members.append(user.pen_names.first)
end
Membership.create!(group: group, member: members[0], position: Membership::MASTER)
Membership.create!(group: group, member: members[1], position: Membership::VICE)
Membership.create!(group: group, member: members[2], position: Membership::CHIEF)
Membership.create!(group: group, member: members[3], position: Membership::COMMON)
Membership.create!(group: group, member: members[4], position: Membership::VISITOR)

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
