Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',   
    omniauth_callbacks: "omniauth_callbacks",
  } 
  
  devise_scope :user do
    # root to: "home#index"
    root to: "users/sessions#new"  
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy" 
  end

  get 'static_pages/top'

  # get 'users/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'static_pages#top'
  # root to: "home#index"
  get '/signup', to: 'users#new'
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'

      
      # get 'shifts/edit_one_month'
      # patch 'shifts/update_one_month'
    end
    resources :shifts do
      member do
        get 'edit_one_month'
        patch 'update_one_month'

        # get 'apply_show'
        get 'apply_edit'
        patch 'apply_update'
        # get 'apply_confirmation_edit'
        # patch 'apply_confirmation_update'
      end
    end
    resources :administrators
  end
end
