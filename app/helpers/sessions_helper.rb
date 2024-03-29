module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user   
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil   
  end

  def signed_in?
    # we call the current_user method, and if it returns a user then this method
    #    returns true, if it returns nil then this method returns false
    self.current_user ? true : false
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def re_route_user
    redirect_to user_path(current_user), :notice => "Please log-out before trying to register as a new user."
  end

  def redirect_back_or(default)
    redirect_to session[:return_to] || default
    clear_return_to
  end
  
  private 

    def current_user=(user)
      @current_user = user
    end
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end

end
