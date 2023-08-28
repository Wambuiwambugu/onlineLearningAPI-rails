class Course < ApplicationRecord
    has_one_attached :image
    validates :title, presence: true
    validates :description, presence: true
    validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

    def image_url
        if image.attached?
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
        end
    end

end
