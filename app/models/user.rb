class User < ApplicationRecord
  has_many :pen_names, dependent: :destroy
  has_many :user_notes, dependent: :destroy
  has_many :user_rooms, dependent: :destroy

  has_many :active_readerships, class_name:  "Readership",
                                  foreign_key: "reader_id",
                                  dependent:   :destroy
  has_many :notes, through: :active_readerships,  source: :note

  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 64 },
                    uniqueness: true

  has_secure_password
  VALID_PASSWORD_REGEX = /(?=.*\d+.*)(?=.*[a-z]+.*)(?=.*[A-Z]+.*).*[\-\+\/\*\%\^\&\|\~\<\=\>\"\'\`\;\:\[\]\{\}\(\)\!\?\@\#\$\,\.\_\\]+.*/
  validates :password, presence: true,
                       length: { minimum: 16, maximum: 64 },
                       format: { with: VALID_PASSWORD_REGEX },
                       allow_nil: true

  mount_uploader :picture, PictureUploader
  validate  :picture_size

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def is_admin?
    self.id == 1
  end

  def groups
    g = []
    for p in self.pen_names do
      g |= p.groups
    end
    g
  end

  def self.can_create?
    site = Site.first
    c1 = site == nil
    c2 = site != nil && site.is_open?
    c1 || c2
  end

  def can_destroy?(user)
    c1 = (self == user)
    c2 = true
    self.pen_names.each do |pen_name|
      unless pen_name.can_destroy?(user)
        c2 = false
        break
      end
    end
    c3 = (self.user_notes.where(status: Note::ST_OPEN).count == 0)
    c4 = (self.user_rooms.where(status: Room::ST_OPEN).count == 0)
    c1 && c2 && c3 && c4
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
