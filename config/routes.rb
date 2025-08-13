Rails.application.routes.draw do
  devise_for :users, skip: [:passwords, :confirmations, :registrations, :unlocks],
             controllers: { sessions: 'users/sessions' }
  
  # Main application routes
  resources :organizations
  resources :teams
  resources :games do
    resources :scoreboards, only: [:show, :edit, :update]
  end
  
  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes will be handled via HTTP Basic Auth
    end
  end
  
  # Redirect root to organizations for now
  root 'organizations#index'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
