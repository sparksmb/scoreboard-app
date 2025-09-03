Rails.application.routes.draw do
  devise_for :users, skip: [:passwords, :confirmations, :registrations, :unlocks],
             controllers: { sessions: 'users/sessions' }
  
  # Main application routes
  resources :organizations do
    get :scoreboard, to: 'live_scoreboards#show'
  end
  resources :teams
  resources :games do
    member do
      post :new_scoreboard
    end
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
  
  # Action Cable
  mount ActionCable.server => '/cable'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
