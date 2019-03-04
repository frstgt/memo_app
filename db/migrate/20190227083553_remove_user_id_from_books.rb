class RemoveUserIdFromBooks < ActiveRecord::Migration[5.1]
  def change
    remove_reference :books, :user, foreign_key: true
    remove_reference :books, :group, foreign_key: true
  end
end
