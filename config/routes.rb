Rails.application.routes.draw do
  devise_for :users, skip: [:passwords, :confirmations, :registrations, :unlocks]
  
  # Admin web interface routes
  namespace :admin do
    resources :organizations
    root 'organizations#index'
  end
  
  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes will be handled via HTTP Basic Auth
    end
  end
  
  # Redirect root to admin for now
  root 'admin/organizations#index'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
