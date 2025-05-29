class CangePostsToSingleCategory < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :post_categories, :posts
    remove_foreign_key :post_categories, :categories

    drop_table :post_categories

    add_reference :posts, :category, foreign_key: true
  end
end
