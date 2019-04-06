class DropTableBooksAndPages < ActiveRecord::Migration[5.1]
  def change
    drop_table :books
    drop_table :pages
  end
end
