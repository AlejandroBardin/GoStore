Rails.application.routes.draw do
  root "course_modules#index"
  
  resources :course_modules, only: [:index]
  resources :exercises, only: [:show]
end
