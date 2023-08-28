class User < ApplicationRecord
    has_secure_password
    has_many :enrollments
    has_many :courses, through: :enrollments
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :role, presence: true
end
