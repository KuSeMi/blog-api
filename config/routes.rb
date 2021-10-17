# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      root 'posts#index'
      resources :users, except: %i[new edit]
      resources :categories, except: %i[new edit]

      resources :posts, except: %i[new edit] do
        resources :comments, except: %i[new edit]
      end

      post '/login',    to: 'sessions#create'
      post '/logout',   to: 'sessions#destroy'
      get '/authorship/:id', to: 'posts#authorship'
      get '/category/:category_id', to: 'posts#category'
    end
  end
end
