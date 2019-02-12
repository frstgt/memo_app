module PenNamesHelper

  def pen_name_icon_for(pen_name, options = { size: 80 })

    if pen_name.picture?
      icon = pen_name.picture.url
    else
      set = [
        ["Number", 10],
        ["Alphabet", 26], ["alphabet", 26],
        ["Greek", 24],    ["greek", 25],
        ["Japanese", 82], ["japanese", 82],
      ]
      id = pen_name.id
      pre, num = set[id%7];
      icon = "pen_name_icons/" + pre + sprintf("%02d", id%num)
    end
    size = options[:size]

    image_tag(icon, alt: pen_name.name,
              width: size, height: size,
              class: "pen_name_icon")
  end

end
