class UsersController < ApplicationController
  before_filter :authenticate,      except:   [:create, :show, :new]
  before_filter :correct_user,      only:     [:edit, :update]
  before_filter :admin_user,        only:     [:destroy]
  before_filter :not_authenticate,  only:     [:new, :create]

  # future updates
  # make show pages only available to signed in users - though it should be available to all


  ## GET users/
  def destroy
    user_name = User.find(params[:id]).name
    
    # check to make sure that admin can't delete their own records
    if (User.find(params[:id]).email != current_user.email)
      User.find(params[:id]).destroy
      flash[:success] = "Success: #{user_name} has been deleted"
      redirect_to users_path
    else 
      flash[:error] = "Error: #{user_name}, you can't delete yourself"
      redirect_to users_path
    end

  end

  ## GET users/
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :per_page => 10)    
  end

  ## GET users/new
  def new
    @title = "Sign Up"
    @user = User.new
    @button_title = @title    
  end
  
  ## POST users
  def create
    @user = User.new(params[:user])     # takes data from form and creates @user instance variable
    if @user.save                       # try to save new @user data
      sign_in @user
      flash[:success] = "Welcome to the Portfolio App!"
      redirect_to @user                     # redirect user to 'show' page (and view)
    else                                # if not able to save @user data
      @title = "Sign Up"                    # set title
      @user.password = ""                    # reset password
      @user.password_confirmation = ""
      render :new                           # render the 'new' view again
    end
  end

  ## GET users/id
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @title = @user.name
  end

  ## GET users/edit
  def edit
    # @user = User.find(params[:id]) #done through authentication via before_filter
    @title = "#{@user.name}: edit profile"
    @button_title = "Update"    
  end

  ## PUT users/id
  def update
    # @user = User.find(params[:id])     # takes data from form and creates @user instance variable
    if @user.update_attributes(params[:user])                       # try to save new @user data
      flash[:success] = "Your profile has been updated!"
      redirect_to @user                     # redirect user to 'show' page (and view)
    else                                # if not able to save @user data
      @title = "#{@user.name}: edit profile" # set title
      render :edit                           # render the 'new' view again
    end
  end
  
  def following
    @title = "following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    # if @users.count > @user.following.count
    #   @users = @user.following
    # end
    @users.uniq!
    render 'users/show_follow'
  end
  
  
  def followers
    @title = "followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    # if @users.count > @user.following.count
    #   @users = @user.following
    # end
    @users.uniq!
    render 'users/show_follow'
  end

  private
  

    def not_authenticate
      re_route_user unless !signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id]) 
      redirect_to root_path unless current_user? @user
    end
    
    def admin_user
      # redirect_to(root_path) unless current_user.respond_to? :admin?     
      redirect_to(root_path) unless current_user.admin?
    end

end
 