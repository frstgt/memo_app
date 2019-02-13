class ChangeDatatypePositionOfMemberships < ActiveRecord::Migration[5.1]
  def change
    change_column :memberships, :position, :integer
  end
end
