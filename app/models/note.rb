class Note < ApplicationRecord

  has_many :active_tagships, class_name:  "Tagship",
                              foreign_key: "note_id",
                              dependent:   :destroy
  has_many :tags, through: :active_tagships,  source: :tag

  default_scope -> { order(updated_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validate  :picture_size

  validates :status,  presence: true

  attr_accessor  :tag_list

  ST_OPEN = 1
  ST_CLOSE = 0
  def to_open
    self.update_attributes({status: ST_OPEN})
  end
  def to_close
    self.update_attributes({status: ST_CLOSE})
  end
  def is_open?
    self.status == ST_OPEN
  end

  def init_tag_list
    self.tag_list = ""
  end
  def load_tag_list
    tag_names = []
    self.tags.each do |tag|
      tag_names.append(tag.name)
    end
    self.tag_list = tag_names.join(",")
  end
  def save_tag_list
    tagships = Tagship.where(note_id: self.id)
    tagships.each do |tagship|
      tag = tagship.tag
      tagship.destroy
      if tag.notes.count == 0
        tag.destroy
      end
    end

    tag_names = self.tag_list.split(",")
    tag_names.each do |tag_name|
      tag = Tag.find_by(name: tag_name)
      unless tag
        tag = Tag.create(name: tag_name)
      end
      Tagship.create(note_id: self.id, tag_id: tag.id)
    end
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
