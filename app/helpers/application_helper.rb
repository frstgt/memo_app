module ApplicationHelper

  def app_name
    "Memolet"
  end

  def full_title(page_title = '')
    base_title = app_name
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def icon_for(object, options = { name: "noname", size: 80 })

    if object and object.picture?
      icon = object.picture.url
    else
      icon = "noimage_icons/noimage.png"
    end
    name = options[:name]
    size = options[:size]

    image_tag(icon, alt: name, width: size, height: size, class: "mr-3 icon")
  end
  
  def timestamp(object, created=true, updated=true)
    timestamp = ""
    timestamp += "created #{time_ago_in_words(object.created_at)} ago." if created
    timestamp += " " if timestamp != ""
    timestamp += "updated #{time_ago_in_words(object.updated_at)} ago." if updated
    timestamp
  end

  def will_pagenate_renderer
    WillPaginate::ActionView::BootstrapLinkRenderer
  end

end
