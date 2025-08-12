Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations, :unlocks]
  
  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes will be handled via HTTP Basic Auth
    end
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "posts#index"
end
