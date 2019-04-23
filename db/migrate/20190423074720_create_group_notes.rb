class CreateGroupNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :group_notes do |t|

      t.timestamps
    end
  end
end
