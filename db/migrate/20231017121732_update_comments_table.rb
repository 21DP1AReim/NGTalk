class UpdateCommentsTable < ActiveRecord::Migration[7.0]
  def change
    remove_index :comments, name: "index_comments_on_commentable_type"
    remove_index :comments, name: "index_comments_on_post_id"
    remove_column :comments, :post_id


    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
    add_reference :comments, :post, null: false, index: true, foreign_key: true, default: 0
    add_column :comments, :commentable_id, :integer
    add_index :comments, :commentable_id
    add_column :comments, :commentable_type, :string
    add_index :comments, :commentable_type
    remove_foreign_key :comments, :posts
  end
end