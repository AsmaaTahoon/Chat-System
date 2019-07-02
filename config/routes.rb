Rails.application.routes.draw do
  post 'messages/search', to: 'messages#search'
  resources :messages
  resources :chats

  resources :applications do
    member do
      get 'chats', to: 'applications#chats', as: :chats
      get 'chats/:chat_number/messages/', to: 'applications#chatMessages', as: :chatMessages
   end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
