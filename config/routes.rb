Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :drivers, only: [:index, :show, :update, :create, :destroy]

  resources :drivers do
    resources :trucks, only: [:index, :create, :update, :destroy]
    resources :driver_licenses, only: [:index, :create, :update, :destroy], :path => "licenses"
    resources :rides, only: [:index, :create, :update, :destroy]
  end

  get '/trucks', to: 'trucks#report'
  get '/rides', to: 'rides#report'
end
