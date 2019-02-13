module GroupsHelper

  def group_icon_for(group, options = { size: 80 })

    if group.picture?
      icon = group.picture.url
    else
      set = [
        ["Yobi", 7], ["Shogi", 11],
        ["Gotoku", 5], ["Kuji", 9],
        ["Jikkan", 10], ["Junishi", 12]
      ]
      id = group.id
      pre, num = set[id%6];
      icon = "group_icons/" + pre + sprintf("%02d", id%num)
    end
    size = options[:size]

    image_tag(icon, alt: group.name,
              width: size, height: size,
              class: "group_icon")
  end

end
