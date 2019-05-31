class AddKeywordToPenNames < ActiveRecord::Migration[5.1]
  def change
    add_column :pen_names, :keyword, :string
  end
end
