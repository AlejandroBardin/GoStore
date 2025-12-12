Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [:new, :create]
  root "course_modules#index"

  resources :course_modules, only: [:index]
  resources :exercises, only: [:show] do
    member do
      post :check_solution
    end
  end

  # PWA files
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
