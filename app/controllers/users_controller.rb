class UsersController < ApplicationController

  ## GET users/new
  def new
    @title = "Sign Up"
    @user = User.new    
  end
  
  ## GET users/id
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  ## POST users
  def create
    @user = User.new(params[:user])     # takes data from form and creates @user instance variable
    if @user.save                       # try to save new @user data
      @title = @user.name                   # set title
      flash[:success] = "Welcome to the Portfolio App!"
      redirect_to @user                     # redirect user to 'show' page (and view)
    else                                # if not able to save @user data
      @title = "Sign Up"                    # set title
      @user.password = ""                    # reset password
      @user.password_confirmation = ""
      render :new                           # render the 'new' view again
    end

  end

end
 