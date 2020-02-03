class AuthController < ApplicationController
  skip_before_action :require_login, only: [:signin]

  def signin
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id }
      token = encode_token(payload)
      render json: { user: user, jwt: token }
    else
      render json: { failure: "Log in failed! Email or password invalid!" }
    end
  end
end
