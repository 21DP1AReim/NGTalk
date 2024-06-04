class ChangeRepliesCommentIdToPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    remove_column :replies, :id
    execute 'PRAGMA foreign_keys = OFF;'
    add_column :replies, :comment_id_temp, :integer
    execute 'UPDATE replies SET comment_id_temp=comment_id'
    change_table :replies do |t|
      t.remove :comment_id
      t.rename :comment_id_temp, :comment_id
      t.index :comment_id, unique: true
    end
    execute 'PRAGMA foreign_keys = ON;'
  end
end