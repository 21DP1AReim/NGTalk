class Category < ApplicationRecord
    #Since one category can be used in many posts define as has many
    #also when a category is deleted, also delete the posts with said category
    has_many :posts, dependent: :destroy
    #Make sure when creation category name is required and name must be unique
    validates :name, presence: true, uniqueness: true 
    #Query for active categories
    scope :active, -> { where(active: true) }
    #Query for incactive categories
    scope :inactive, -> { where(active: false) }
end