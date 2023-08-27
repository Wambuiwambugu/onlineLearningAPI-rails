Rails.application.routes.draw do
  post '/register', to: 'users#register'
  post '/login', to: 'users#login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
