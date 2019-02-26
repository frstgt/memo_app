password = "z8aKm$@3rTEp#+bs"

User.create!(name:  "Example User",
             password:              password,
             password_confirmation: password)
29.times do |n|
  name  = Faker::Name.name + "2019"
  User.create!(name:  name,
               password:              password,
               password_confirmation: password)
end
users = User.order(:created_at)

# groups
3.times do |n|
  name  = Faker::Team.name + "2019"
  description = Faker::Lorem.sentence(20)
  Group.create!(name: name, description: description)
end
groups = Group.order(:created_at)

# pen names
users.each { |user|

  2.times do
    name = Faker::Name.name + "2019"
    description = Faker::Lorem.sentence(20)
    user.pen_names.create!(name: name, description: description)
  end
}

# memberships
members = []
for user in users do
  members.append(user.pen_names.first)
end
groups.each_with_index { |group, n|

  Membership.create!(group: group, member: members[n*10+0], position: Membership::MASTER)
  Membership.create!(group: group, member: members[n*10+1], position: Membership::VICE)
  Membership.create!(group: group, member: members[n*10+2], position: Membership::CHIEF)
  Membership.create!(group: group, member: members[n*10+3], position: Membership::CHIEF)
  Membership.create!(group: group, member: members[n*10+4], position: Membership::COMMON)
  Membership.create!(group: group, member: members[n*10+5], position: Membership::COMMON)
  Membership.create!(group: group, member: members[n*10+6], position: Membership::COMMON)
  Membership.create!(group: group, member: members[n*10+7], position: Membership::COMMON)
  Membership.create!(group: group, member: members[n*10+8], position: Membership::COMMON)
  Membership.create!(group: group, member: members[n*10+9], position: Membership::VISITOR)
}

# user_notes
users.each { |user|
  pen_names = user.pen_names
  pen_names.each { |pen_name|

    2.times do
      title = Faker::Book.title
      description = Faker::Lorem.sentence(20)
      user.user_notes.create!(title: title, description: description, pen_name_id: pen_name.id)
    end
  }
}
# user_memos
users.each { |user|
  notes = user.user_notes
  notes.each { |note|

      number = 1
      10.times do
        content = Faker::Lorem.sentence(20)
        note.user_memos.create!(content: content, number: number)
        number += 1
      end
    }
}

# group_notes
groups.each { |group|
  pen_names = group.members
  pen_names.each { |pen_name|

    2.times do
      title = Faker::Book.title
      description = Faker::Lorem.sentence(20)
      group.group_notes.create!(title: title, description: description, pen_name_id: pen_name.id)
    end
  }
}
# group_memos
groups.each { |group|
  notes = group.group_notes
  notes.each { |note|

      number = 1
      10.times do
        content = Faker::Lorem.sentence(20)
        note.group_memos.create!(content: content, number: number)
        number += 1
      end
    }
}

# books
users.each { |user|
  pen_names = user.pen_names
  pen_names.each { |pen_name|

    title = Faker::Book.title
    author = pen_name.name
    description = Faker::Lorem.sentence(20)
    protection = Book::PRIVATE
    user.books.create!(title: title, author: author, description: description,
                          pen_name_id: pen_name.id, protection: protection)

    title = Faker::Book.title
    author = pen_name.name
    description = Faker::Lorem.sentence(20)
    protection = Book::SITE
    user.books.create!(title: title, author: author, description: description,
                          pen_name_id: pen_name.id, protection: protection)

    title = Faker::Book.title
    author = pen_name.name
    description = Faker::Lorem.sentence(20)
    protection = Book::PUBLIC
    user.books.create!(title: title, author: author, description: description,
                          pen_name_id: pen_name.id, protection: protection)
  }
}
# pages
users.each { |user|
  books = user.books
  books.each { |book|

      10.times do
        content = Faker::Lorem.sentence(20)
        book.pages.create!(content: content)
      end
    }
}
