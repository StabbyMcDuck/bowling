Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :games, except: [ :edit, :index, :new ]
      resources :players, except: [ :edit, :new ]
      resources :frames, except: [ :edit, :new ]
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end
