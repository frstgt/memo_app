class CreateGroupRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :group_rooms do |t|

      t.timestamps
    end
  end
end
