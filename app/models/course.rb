class Course < ApplicationRecord
    has_one_attached :image
    has_many :lessons
    has_many :enrollments
    has_many :users, through: :enrollments
    validates :title, presence: true
    validates :description, presence: true
    validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

    def image_url
        Rails.application.routes.url_helpers.rails_blob_path(image) if image.attached?
    end

end
