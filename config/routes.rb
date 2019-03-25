Rails.application.routes.draw do
  resources :users, only: [:create]
  devise_for :users, :controllers => { omniauth_callbacks: 'callbacks' }
  resources :users, except: [:edit, :update] do
    member do
      put 'change_password'
    end

    resources :core_demographics, only: [:create, :update]
    resources :user_extend_demographies, only: [:create, :update], controller: :extend_demographies

  end
  resources :rooms do
    resources :meetings
  end
  get 'fetch/:action', controller: 'fetch'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  # Miscellaneous
  get 'miscellaneous/login',
      to: 'miscellaneous#login',
      as: :miscellaneous_login
  get 'miscellaneous/register',
      to: 'miscellaneous#register',
      as: :miscellaneous_register
  get 'miscellaneous/forgot_password',
      to: 'miscellaneous#forgot_password',
      as: :miscellaneous_forgot_password
  get 'miscellaneous/locked_screen',
      to: 'miscellaneous#locked_screen',
      as: :miscellaneous_locked_screen

  # AJAX
  get 'ajax/email_compose', to: 'ajax#email_compose', as: :ajax_email_compose
  get 'ajax/email_list', to: 'ajax#email_list', as: :ajax_email_list
  get 'ajax/email_opened', to: 'ajax#email_opened', as: :ajax_email_opened
  get 'ajax/email_reply', to: 'ajax#email_reply', as: :ajax_email_reply
  get 'ajax/demo_widget', to: 'ajax#demo_widget', as: :ajax_demo_widget
  get 'ajax/data_list.json', to: 'ajax#data_list', as: :ajax_data_list
  get 'ajax/notify_mail', to: 'ajax#notify_mail', as: :ajax_notify_mail
  get 'ajax/notify_notifications',
      to: 'ajax#notify_notifications',
      as: :ajax_notify_notifications
  get 'ajax/notify_tasks', to: 'ajax#notify_tasks', as: :ajax_notify_tasks

  # Misc methods
  get '/home/set_locale', to: 'home#set_locale', as: :home_set_locale

  # CK editor


  resources :settings, only: [:index, :create] do
    collection do
      post 'set_user_auth'
      post 'set_notification'
      post 'set_modules'
      post 'set_theme'
      post 'set_key_providers'
    end
  end
end
