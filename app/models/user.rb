class User < ApplicationRecord
    has_secure_password
    has_many :enrollments
    has_many :courses, through: :enrollments
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :role, presence: true

    def enrolled_in?(course)
        enrollments.exists?(course_id: course.id)
    end
    
    def enroll_in(course)
        enrollments.create(course_id: course.id)
    end

    def unenroll_from(course)
        enrollments.where(course_id: course.id).destroy_all
    end
end
