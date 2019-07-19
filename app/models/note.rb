class Note < ApplicationRecord
  belongs_to :pen_name, optional: true

  has_many :memos, dependent: :destroy
  has_many :pictures, dependent: :destroy

  has_many :active_tagships, class_name:  "Tagship",
                              foreign_key: "note_id",
                              dependent:   :destroy
  has_many :tags, through: :active_tagships,  source: :tag

  has_many :passive_readerships, class_name:  "Readership",
                                  foreign_key: "note_id",
                                  dependent:   :destroy
  has_many :readers, through: :passive_readerships,  source: :reader

  default_scope -> { order(updated_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :title, presence: true, length: { maximum: 100 }
  validates :outline, length: { maximum: 1000 }
  validate  :picture_size

  validates :status,  presence: true
  validates :numbering,  presence: true

  attr_accessor  :tag_list

  ST_WEB = 2
  ST_OPEN = 1
  ST_CLOSE = 0
  def is_web?
    self.status == ST_WEB
  end
  def is_open?
    self.status == ST_OPEN
  end

  NUM_ADD_FIRST = 1
  NUM_ADD_LAST = 0
  def add_first?
    self.numbering == NUM_ADD_FIRST
  end
  def add_last?
    self.numbering == NUM_ADD_LAST
  end

  def load_tag_list
    tag_names = []
    self.tags.each do |tag|
      tag_names.append(tag.name)
    end
    self.tag_list = tag_names.join(",")
  end
  def save_tag_list
    active_tagships.each do |tagship|
      tag = tagship.tag
      tagship.destroy
      if tag.notes.count == 0
        tag.destroy
      end
    end

    if self.tag_list
      tag_names = self.tag_list.split(",")
      tag_names.each do |tag_name|
        tag = Tag.find_by(name: tag_name)
        unless tag
          tag = Tag.create(name: tag_name)
        end
        active_tagships.create(tag_id: tag.id)
      end
    end
  end

  def set_point(user, point)
    readership = passive_readerships.find_by(reader_id: user.id)
    if readership
      if point == 0
        readership.destroy
      else
        readership.update_attributes({point: point})
      end
    else
      passive_readerships.create(reader_id: user.id, point: point)
    end
  end
  def get_point(user)
    readership = passive_readerships.find_by(reader_id: user.id)
    if readership
      readership.point
    else
      0
    end
  end

  def self.positive_list(user)
    note_ids = "SELECT note_id FROM readerships
                  WHERE reader_id = :user_id AND point > 0"
    Note.where("id IN (#{note_ids})", user_id: user.id)
  end
  def self.negative_list(user)
    note_ids = "SELECT note_id FROM readerships
                  WHERE reader_id = :user_id AND point < 0"
    Note.where("id IN (#{note_ids})", user_id: user.id)
  end
  def self.non_negative_list(user)
    note_ids = "SELECT note_id FROM readerships
                  WHERE reader_id = :user_id AND point < 0"
    Note.where.not("id IN (#{note_ids})", user_id: user.id)
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
