class CoursesController < ApplicationController
   
    before_action :authorized, except: [:index, :show]
    before_action :authorize_admin_or_teacher, only: [:create, :update, :destroy]

    # Get all courses
    def index
        courses = Course.all
        render json: courses, methods: :image_url, status: :ok
        # render json: courses.as_json(include: :image).merge(image: courses.image.map do |image|
        #   url_for(image)
        # end
        # )
    end

    # Get specific course
    def show
        course = Course.find(params[:id])
        render json: course,serializer: CourseSerializer, status: :ok
    end

    # Create course
    def create
        course = Course.new(course_params)
        if course.save
          render json: course, status: :created, serializer: CourseSerializer
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # Update a course
    def update
        course = Course.find(params[:id])
        if course.update(course_params)
          render json: course, status: :ok
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    # Delete course
    def destroy
        course = Course.find(params[:id])
        course.destroy
        head :no_content
    end

    # Enroll a user to a course
    def enroll
      course = Course.find(params[:id])
      
      if current_user.enrolled_in?(course)
        render json: { error: 'Already enrolled in this course' }, status: :unprocessable_entity
      else
        current_user.enroll_in(course)
        render json: { message: 'Enrolled successfully' }, status: :ok
      end
    end

    # Unenroll user from a course
    def unenroll
      course = Course.find(params[:id])
      
      if current_user.enrolled_in?(course)
        current_user.unenroll_from(course)
        render json: { message: 'Unenrolled successfully' }, status: :ok
      else
        render json: { error: 'Not enrolled in this course' }, status: :unprocessable_entity
      end
    end
    
    private
    
    def course_params
        params.require(:course).permit(:title, :description, :instructor, :rating, :image)
    end

   

end
