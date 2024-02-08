# frozen_string_literal: true

Rails.application.routes.draw do
  post 'transfers', to: 'transfers#create'
end
