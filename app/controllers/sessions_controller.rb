class SessionsController < ApplicationController
  def new
    @title = "Log in"
    @user = User.new
  end

  def create
    user = User.authenticate(params[:session][:email], 
                             params[:session][:password])     
    if user.nil?            # if user was NOT authenticated
      flash.now[:error] = "Invalid email and password combination. Please re-enter information."
      @title = "Log in"
      render :new           # render the 'new' view again
    else                    # if user WAS authenticated
      sign_in user          # 
      redirect_back_or user     # redirect user to 'show' page (and view)
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
