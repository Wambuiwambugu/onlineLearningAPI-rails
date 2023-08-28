Rails.application.routes.draw do
  post '/register', to: 'users#register'
  post '/login', to: 'users#login'

  resources :courses do
    resources :lessons
    resources :assignments
    resources :quizzes
    member do
      post 'enroll'
      delete 'unenroll'
    end
  end
  resources :submissions, only: [:create]
end
