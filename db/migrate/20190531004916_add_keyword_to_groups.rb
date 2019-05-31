class AddKeywordToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :keyword, :string
  end
end
