class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :rating, :image_url, :lessons, :creator_id
end
