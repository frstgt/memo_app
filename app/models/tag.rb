class Tag < ApplicationRecord

  has_many :passive_tagships, class_name:  "Tagship",
                              foreign_key: "tag_id",
                              dependent:   :destroy
  has_many :notes, through: :passive_tagships,  source: :note

  validates :name, presence: true

end
