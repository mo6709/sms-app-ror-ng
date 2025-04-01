Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get "approval_records" => 'approval_records#index', defaults: { format: :json }
      post "approval_records" => 'approval_records#create', defaults: { format: :json }

      resource :approval_records_reports do
        member do
          get 'download', constraints: { format: 'pdf' }
        end
      end

      devise_for :users,
                 defaults: { format: :json },
                 controllers: {
                   sessions: 'api/v1/sessions',
                   registrations: 'api/v1/registrations'
                 },
                 path: 'auth',
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'register'
                 }
      # get 'sms/:id', to: 'sms#show'
      resources :sms, only: [:create, :index, :show, :destroy] do
        collection do
          post :status
        end
      end
    end
  end
end