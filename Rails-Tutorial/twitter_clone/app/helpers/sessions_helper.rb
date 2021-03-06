module SessionsHelper

  def log_in(user)
    # session method defined by Rails, treat it like a hash
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # retrieve the user if a temp session exists, otherwise retrieve the cookie and login the user
  def current_user
    if (user_id = session[:user_id])
      # #find_by returns nil, whereas #find throws an exception, if user not found
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  # returns true if the given user is the current user
  def current_user?(user)
    user == current_user
  end

  # a user is logged if there is a current user in the session
  def logged_in?
    !current_user.nil?
  end

  # generate a persistent session
  def remember(user)
    # generate token and save to dbase
    user.remember
    # save the encrypted user_id to a cookie
    cookies.permanent.signed[:user_id] = user.id
    # save the token, with a 20 yr expiry, to the token
    cookies.permanent[:remember_token] = user.remember_token
  end

  # delete a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # rediect to the stored location, or to the default
  def redirect_back_or(default)
    # redirect's don't happen until after an explicit return or the end of the method
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # store the url trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
