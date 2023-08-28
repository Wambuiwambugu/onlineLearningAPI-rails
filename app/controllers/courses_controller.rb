class CoursesController < ApplicationController
    before_action :authorized, except: [:index, :show]
    before_action :authorize_admin_or_teacher, only: [:create, :update, :destroy]

    def index
        courses = Course.all
        render json: courses, methods: :image_url, status: :ok
        # render json: courses.as_json(include: :image).merge(image: courses.image.map do |image|
        #   url_for(image)
        # end
        # )
    end

    def show
        course = Course.find(params[:id])
        render json: course, status: :ok
    end

    def create
        course = Course.new(course_params)
        if course.save
          render json: course, status: :created
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        course = Course.find(params[:id])
        if course.update(course_params)
          render json: course, status: :ok
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def destroy
        course = Course.find(params[:id])
        course.destroy
        head :no_content
    end
    
    private
    
    def course_params
        params.require(:course).permit(:title, :description, :instructor, :rating, :image)
    end

end
