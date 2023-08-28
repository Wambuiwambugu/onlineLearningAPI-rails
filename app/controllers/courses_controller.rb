class CoursesController < ApplicationController
    before_action :authorized, except: [:index, :show]

    def index
        render json: {'courses': "new ones"}
    end
end
