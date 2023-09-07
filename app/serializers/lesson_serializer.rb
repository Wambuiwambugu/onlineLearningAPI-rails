class LessonSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :video_link
end
