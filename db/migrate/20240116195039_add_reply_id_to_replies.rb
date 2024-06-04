class AddReplyIdToReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :replies, :reply_id, :integer
    add_foreign_key :replies, :replies, column: :reply_id
  end
end
