class CheckController < ApplicationController
  skip_before_action :require_login, only: [:ping]

  def ping
    render json: { message: 'pong'}
  end
end
