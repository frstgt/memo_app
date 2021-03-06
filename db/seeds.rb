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

# pen names
users.each do |user|

  2.times do
    name = Faker::Name.name
    outline = Faker::Lorem.sentence(20)
    status = [PenName::ST_CLOSE, PenName::ST_OPEN].sample
    keyword = "this-is-keyword-for-pen-name"
    user.pen_names.create!(name: name, outline: outline, status: status, keyword: keyword)
  end
end

# groups
2.times do |n|
  name  = Faker::Team.name
  outline = Faker::Lorem.sentence(20)
  status = [Group::ST_CLOSE, Group::ST_OPEN].sample
  keyword = "this-is-keyword-for-group"
  Group.create!(name: name, outline: outline, status: status, keyword: keyword)
end
groups = Group.order(:created_at)

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

# tags
["tag1", "tag2", "tag3", "tag4", "tag5"].each do |name|
  Tag.create(name: name)
end
tag_ids = []
Tag.order(:created_at).each do |tag|
  tag_ids.append(tag.id)
end
tag_ids.append(nil)

# user_notes/memos
users.each do |user|

  pen_name_ids = []
  user.pen_names.each do |pen_name|
    pen_name_ids.append(pen_name.id)
  end
  pen_name_ids.append(nil)

  3.times do
    pen_name_id = pen_name_ids.sample
      
    title = Faker::Book.title
    outline = Faker::Lorem.sentence(20)
    status = [Note::ST_CLOSE, Note::ST_OPEN, Note::ST_WEB].sample
    if pen_name_id == nil
      status = Note::ST_CLOSE
    end
    note = user.user_notes.create!(title: title, outline: outline,
                                  pen_name_id: pen_name_id, status: status)

    number = 1
    10.times do
      title = Faker::Book.title
      content = Faker::Lorem.sentence(20)
      note.memos.create!(title: title, content: content, number: number)
      number += 1
    end

    tag_id = tag_ids.sample
    Tagship.create(note_id: note.id, tag_id: tag_id)
  end
end

# group_notes/memos
groups.each do |group|

  pen_name_ids = []
  group.members.each do |pen_name|
    pen_name_ids.append(pen_name.id)
  end
  pen_name_ids.append(nil)  

  15.times do
    pen_name_id = pen_name_ids.sample

    title = Faker::Book.title
    outline = Faker::Lorem.sentence(20)
    status = [Note::ST_CLOSE, Note::ST_OPEN, Note::ST_WEB].sample
    note = group.group_notes.create!(title: title, outline: outline,
                                    pen_name_id: pen_name_id, status: status)

    number = 1
    10.times do
      title = Faker::Book.title
      content = Faker::Lorem.sentence(20)
      note.memos.create!(title: title, content: content, number: number)
      number += 1
    end

    tag_id = tag_ids.sample
    Tagship.create(note_id: note.id, tag_id: tag_id)
  end
end

# readerships
users.each do |user|
  Note.order(:updated_at).each do |note|
    point = Array(-5..5).sample
    note.passive_readerships.create(reader_id: user.id, point: point)
  end
end

# group_rooms/messages
groups.each do |group|

  pen_name_ids = []
  group.members.each do |pen_name|
    pen_name_ids.append(pen_name.id)
  end
  pen_name_ids.append(nil)  

  3.times do
    title = Faker::Book.title
    outline = Faker::Lorem.sentence(20)
    pen_name_id = pen_name_ids.sample
    status = [Room::ST_CLOSE, Room::ST_OPEN].sample
    room = group.group_rooms.create(title: title, outline: outline,
                                    pen_name_id: pen_name_id, status: status)

    5.times do
      member = group.members.sample
      content = Faker::Lorem.sentence(5)
      room.messages.create!(content: content, pen_name_id: member.id)
    end
  end
end

# user_rooms/messages
users.each do |user|

  pen_name_ids = []
  user.pen_names.each do |pen_name|
    pen_name_ids.append(pen_name.id)
  end
  pen_name_ids.append(nil)

  3.times do
    title = Faker::Book.title
    outline = Faker::Lorem.sentence(20)
    pen_name_id = pen_name_ids.sample
    status = [Room::ST_CLOSE, Room::ST_OPEN].sample
    if pen_name_id == nil
      status = Room::ST_CLOSE
    end
    room = user.user_rooms.create(title: title, outline: outline,
                                  pen_name_id: pen_name_id, status: status)

    5.times do
      pen_name = PenName.order(:created_at).sample
      content = Faker::Lorem.sentence(5)
      room.messages.create!(content: content, pen_name_id: pen_name.id)
    end
  end
end

# end of file