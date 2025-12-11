Rails.application.routes.draw do
  root "course_modules#index"
  
  resources :course_modules, only: [:index]
  resources :exercises, only: [:show]

  # PWA files
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
