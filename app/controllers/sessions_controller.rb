class SessionsController < ApplicationController
  skip_before_action :logged_in_user, only: [:new, :create]
  
  def new
  end

  def create
    email = params[:session][:email].downcase
    pwd = params[:session][:password]
    user = User.find_by(email: email)
    if user && user.authenticate(pwd) #primero chequea que exista el user y después autentica
      log_in user
      redirect_to user
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to login_url
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end