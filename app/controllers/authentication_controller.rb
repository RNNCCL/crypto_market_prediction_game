class AuthenticationController < ApplicationController
  def login
    user = User.find_by_email!(params[:email])

    raise unless user.password == params[:password]

    response = success_response(user)

    render json: response
  rescue Exception => error
    # render json: { error: error }, status: 200
    render json: { error: 'Wrong credentials' }, status: 200
  end

  def signup
    user = User.create!(person_params)

    response = success_response(user)

    render json: response
  rescue Exception => error
    render json: { error: error }, status: 404
  end

  private

  def person_params
    params.require(:user).permit(:email, :password, :username)
  end

  def success_response user
    payload = { creation_date: user.created_at, id: user.id }

    {
      email: user.email,
      username: user.username,
      token: JsonWebToken.encode(payload)
    }
  end
end
