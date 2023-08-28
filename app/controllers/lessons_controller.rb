class LessonsController < ApplicationController
    before_action :set_course

    def index
        lessons = if user_enrolled?
                    @course.lessons
                  else
                    @course.lessons.limit(2) # Show only two lessons for unenrolled users
                  end
    
        render json: lessons
    end

    def show 
        lesson = Lesson.find(params[:id])
        render json: lesson, status: :ok
    end

    def create
        lesson = @course.lessons.new(lesson_params)
        if lesson.save
          render json: lesson, status: :created
        else
          render json: { error: lesson.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end
    
    private
    
    def user_enrolled?
        @course.users.include?(current_user)
    end

    def set_course
        @course = Course.find(params[:course_id])
    end
    
    def lesson_params
        params.require(:lesson).permit(:title, :content, :video_link)
    end
end
