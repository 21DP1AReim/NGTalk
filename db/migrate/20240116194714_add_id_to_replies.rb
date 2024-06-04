class AddIdToReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :replies, :id, :primary_key
  end
end
