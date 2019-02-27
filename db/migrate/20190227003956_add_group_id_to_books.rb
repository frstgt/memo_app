class AddGroupIdToBooks < ActiveRecord::Migration[5.1]
  def change
    add_reference :books, :group, foreign_key: true
  end
end
