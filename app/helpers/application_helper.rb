module ApplicationHelper

  def full_title(page_title = '')
    base_title = "Memo App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def icon_for(object, options = { name: noname, size: 80 })

    if object.picture?
      icon = object.picture.url
    else
      icon = "noimage_icons/noimage.png"
    end
    name = options[:name]
    size = options[:size]

    image_tag(icon, alt: name, width: size, height: size, class: "icon")
  end

end
