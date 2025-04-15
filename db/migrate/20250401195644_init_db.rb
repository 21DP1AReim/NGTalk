class InitDb < ActiveRecord::Migration[7.0]
  def change
    create_table "users" do |t|
      t.string "user_name", null: false, default: ""
      t.string "email", null: false, default: ""
      t.string "encrypted_password", null: false, default: ""
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.string "role", default: "user"
      t.datetime "banned_at"
      t.datetime "ban_expires_at"
      t.text "ban_reason"
      t.timestamps

      t.index ["email"], unique: true
      t.index ["reset_password_token"], unique: true
      t.index ["user_name"], unique: true
    end

    create_table "posts" do |t|
      t.string "title", null: false
      t.text "content", null: false
      t.string "post_type", null: false
      t.integer "author_id", null: false
      t.datetime "archived_at"
      t.timestamps
    end

    create_table "categories" do |t|
      t.string "name", null: false
      t.timestamps
      t.index ["name"], unique: true
    end

    create_table "post_categories" do |t|
      t.integer "post_id", null: false
      t.integer "category_id", null: false
      t.timestamps
      t.index ["post_id", "category_id"], unique: true
    end

    create_table "comments" do |t|
      t.text "body", null: false
      t.integer "user_id", null: false
      t.integer "post_id", null: false
      t.integer "parent_id"
      t.timestamps
    end

    create_table "notifications" do |t|
      t.integer "user_id", null: false
      t.integer "post_id"
      t.integer "actor_id"
      t.string "notification_type", null: false
      t.text "message"
      t.datetime "read_at"
      t.timestamps
    end

    add_foreign_key "posts", "users", column: "author_id"
    add_foreign_key "post_categories", "posts"
    add_foreign_key "post_categories", "categories"
    add_foreign_key "comments", "users"
    add_foreign_key "comments", "posts"
    add_foreign_key "comments", "comments", column: "parent_id"
    add_foreign_key "notifications", "users"
    add_foreign_key "notifications", "posts"
    add_foreign_key "notifications", "users", column: "actor_id"

  end
end