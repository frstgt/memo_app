class RemoveProtectionFromBooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :protection, :integer
  end
end
