module SessionsHelper

  def log_in(user)
    session[:this_user] = user.id
  end

  def current_user
    if session[:this_user]
      @current_user ||= User.find_by(id: session[:this_user])
    end
  end
    
  # Returns true if the user is logged in, failse otherwise.
  def logged_in?
    !current_user.nil?
  end
    
  # Logs out the current user.
  def log_out
    session.delete(:this_user)
    @current_user = nil
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
    
end
    