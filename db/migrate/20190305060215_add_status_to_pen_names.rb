class AddStatusToPenNames < ActiveRecord::Migration[5.1]
  def change
    add_column :pen_names, :status, :integer, default: 0
  end
end
