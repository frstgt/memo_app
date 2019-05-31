class AddKeywordToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :keyword, :string
  end
end
