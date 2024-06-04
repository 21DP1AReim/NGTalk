class AddCommentableToReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :replies, :commentable_id, :integer
    add_column :replies, :commentable_type, :string
    add_index :replies, [:commentable_type, :commentable_id]
  end
end
