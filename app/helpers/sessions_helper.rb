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
  
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  ################
  ## TEST/EXERCISE : START : USING SESSIONS RATHER THAN COOKIES
  def session_sign_in(user)
    session[:user] = user
    self.session_current_user = user   
  end

  def session_sign_out
    session[:user] = nil
    self.session_current_user = nil   
  end

  def session_signed_in?
    # we call the current_user method, and if it returns a user then this method
    #    returns true, if it returns nil then this method returns false
    self.session_current_user ? true : false
  end

  def session_current_user=(user)
    @session_current_user = user
  end

  def session_current_user
    @session_current_user ||= session[:user]
  end
  ## TEST/EXERCISE : END : USING SESSIONS RATHER THAN COOKIES
  ################

  private 
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
