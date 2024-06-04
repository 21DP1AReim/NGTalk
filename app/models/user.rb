  class User < ApplicationRecord
    validate :userName_cannot_contain_symbol
    ROLES = %w[admin editor writer user]

    def admin?
      role == 'admin'
    end
    
    def editor?
      role == 'editor'
    end

    def writer?
      role = 'writer'
    end

    def user?
      role = 'user'
    end

    def self.ransackable_attributes(auth_object = nil)
      ["email", "userName"]
    end

    validates :userName, presence: true
    validate :validate_userName_format

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    private

    def validate_userName_format
      unless userName.match?(/\A(?=.*[A-Za-z])\w+\z/) && userName.length >= 3
        if userName.length < 3
              errors.add(:userName, "must be longer than 3 characters")
            elsif !userName.match?(/[A-Za-z]/)
              errors.add(:userName, "must contain at least one letter")
            else
              errors.add(:userName, "must contain only letters, numbers, and underscores")
            end
          end
        end

    def userName_cannot_contain_symbol
      if userName&.include?('@')
        errors.add(:userName, "can't contain '@'")
      end
      if userName&.include?(' ')
        errors.add(:userName, "can't contain whitespace")
      end
    end
  end