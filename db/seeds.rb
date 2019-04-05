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
users = User.order(:created_at)

# groups
2.times do |n|
  name  = Faker::Team.name
  description = Faker::Lorem.sentence(20)
  Group.create!(name: name, description: description,
                status: 1)
end
groups = Group.order(:created_at)

# pen names
users.each do |user|

  2.times do
    name = Faker::Name.name
    description = Faker::Lorem.sentence(20)
    user.pen_names.create!(name: name, description: description,
                          status: 1)
  end
end

# memberships
members = []
for user in users do
  members.append(user.pen_names.first)
end
groups.each_with_index { |group, n|
  Membership.create!(group: group, member: members[n*5+0], position: Membership::POS_LEADER)
  Membership.create!(group: group, member: members[n*5+1], position: Membership::POS_SUBLEADER)
  Membership.create!(group: group, member: members[n*5+2], position: Membership::POS_COMMON)
  Membership.create!(group: group, member: members[n*5+3], position: Membership::POS_COMMON)
  Membership.create!(group: group, member: members[n*5+4], position: Membership::POS_VISITOR)
}

# messages
groups.each do |group|
  10.times do
    member = group.members.sample
    content = Faker::Lorem.sentence(10)
    group.messages.create!(content: content, group_id: group.id, pen_name_id: member.id)
  end
end

# user_notes
users.each do |user|
  pen_names = user.pen_names
  pen_names.each do |pen_name|

    2.times do
      title = Faker::Book.title
      description = Faker::Lorem.sentence(20)
      note = user.user_notes.create!(title: title, description: description,
                                    pen_name_id: pen_name.id)

      number = 1
      10.times do
        title = Faker::Book.title
        content = Faker::Lorem.sentence(20)
        note.user_memos.create!(title: title, content: content,
                                number: number)
        number += 1
      end
    end
  end
end

# group_notes
groups.each do |group|
  pen_names = group.members
  pen_names.each do |pen_name|

    2.times do
      title = Faker::Book.title
      description = Faker::Lorem.sentence(20)
      note = group.group_notes.create!(title: title, description: description,
                                      pen_name_id: pen_name.id, status: 1)

      number = 1
      10.times do
        title = Faker::Book.title
        content = Faker::Lorem.sentence(20)
        note.group_memos.create!(title: title, content: content,
                                number: number)
        number += 1
      end
    end
  end
end

# books by user
users.each do |user|
  pen_names = user.pen_names
  pen_names.each do |pen_name|

    title = Faker::Book.title
    author = pen_name.name
    description = Faker::Lorem.sentence(20)
    book = Book.create!(title: title, author: author, description: description,
                  pen_name_id: pen_name.id, group_id: nil)
    10.times do
      title = Faker::Book.title
      content = Faker::Lorem.sentence(20)
      book.pages.create!(title: title, content: content,
                          book_id: book.id)
    end
  end
end

# books by group
groups.each do |group|
  pen_names = group.members
  pen_names.each do |pen_name|

    title = Faker::Book.title
    author = pen_name.name + " @ " + group.name
    description = Faker::Lorem.sentence(20)
    book = Book.create!(title: title, author: author, description: description,
                         pen_name_id: pen_name.id, group_id: group.id)

    10.times do
      title = Faker::Book.title
      content = Faker::Lorem.sentence(20)
      book.pages.create!(title: title, content: content,
                        book_id: book.id)
    end
  end
end

# readerships
users.each do |user|
  books = Book.order(:created_at)
  books.each do |book|
    evaluation = [-5,-4,-3,-2,-1,0,1,2,3,4,5].sample
    Readership.create!(reader_id: user.id, book_id: book.id, evaluation: evaluation)
  end
end
