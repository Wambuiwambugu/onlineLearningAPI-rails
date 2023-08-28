class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :rating
end
