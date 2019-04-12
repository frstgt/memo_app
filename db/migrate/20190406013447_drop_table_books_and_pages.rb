class DropTableBooksAndPages < ActiveRecord::Migration[5.1]
  def change
    drop_table :books
    drop_table :pages
    drop_table :readerships
  end
end
