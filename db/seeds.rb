# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# db/seeds.rb

# Clear existing data
Notification.delete_all 
Comment.delete_all
Post.delete_all
Category.delete_all
User.delete_all


# Create sample users
users = [
  { user_name: 'admin', email: 'admin@inbox.lv', password: 'password', role: 'admin' },
  { user_name: 'editor1', email: 'editor1@inbox.lv', password: 'password', role: 'editor' },
  { user_name: 'writer1', email: 'writer1@inbox.lv', password: 'password', role: 'writer' },
  { user_name: 'user1', email: 'user1@inbox.lv', password: 'password' },
  { user_name: 'user2', email: 'user2@inbox.lv', password: 'password' }
]

users.each do |user_attrs|
  User.create!(user_attrs)
end


# Create categories
categories = ['Technology', 'Science', 'Arts', 'Politics', 'Sports', 'Health']
categories.each do |category_name|
  Category.create!(name: category_name)
end


# Sample post content
post_samples = [
  {
    title: 'Getting Started with Ruby on Rails',
    content: 'Ruby on Rails is a popular web application framework...',
    post_type: 'article',
    categories: ['Technology'],
    author: 'editor1'
  },
  {
    title: 'The Future of Artificial Intelligence',
    content: 'AI is transforming industries across the globe...',
    post_type: 'article',
    categories: ['Technology', 'Science'],
    author: 'writer1'
  },
  {
    title: 'Local Sports Team Wins Championship',
    content: 'In an exciting match last night, our local team...',
    post_type: 'post',
    categories: ['Sports'],
    author: 'user1'
  },
  {
    title: 'New Health Study Reveals Benefits of Exercise',
    content: 'A recent study published in the Journal of Health...',
    post_type: 'article',
    categories: ['Health'],
    author: 'editor1'
  },
  {
    title: 'Community Forum Rules Update',
    content: 'We have updated our community guidelines...',
    post_type: 'post',
    categories: ['Politics'],
    author: 'admin'
  },
  {
    title: 'Upcoming Art Exhibition in Downtown',
    content: 'The city art museum will host a special exhibition...',
    post_type: 'post',
    categories: ['Arts'],
    author: 'user2'
  }
]

# Create posts
post_samples.each do |post_data|
  author = User.find_by!(user_name: post_data[:author])
  
  # Find the FIRST category in the array (since posts now have one category)
  category = Category.find_by!(name: post_data[:categories].first)

  post = Post.create!(
    title: post_data[:title],
    content: post_data[:content],
    post_type: post_data[:post_type],
    author_id: author.id,
    category_id: category.id,
    created_at: rand(1..30).days.ago,
    updated_at: rand(1..30).days.ago
  )
  
  # Save the post with categories
  post.save!
  


end
