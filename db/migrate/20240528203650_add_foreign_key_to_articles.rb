class AddForeignKeyToArticles < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key "articles", "users", column: "author"
  end
end
