class SessionsController < ApplicationController
  def new
    @title = "Log in"
    @user = User.new
  end

  def create
    user = User.authenticate(params[:session][:email], 
                             params[:session][:password])     
    if user.nil?            # if user was authenticated
      flash.now[:error] = "Invalid email and password combination. Please re-enter information."
      @title = "Log in"
      render :new                   # render the 'new' view again
    else                            # try to save new @user data
      # sign_in user
      session_sign_in user
      redirect_to user_path(user)         # redirect user to 'show' page (and view)
    end
  end

  def destroy
    # sign_out
    session_sign_out
    redirect_to root_path
  end

end
