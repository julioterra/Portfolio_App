class MicropostsController < ApplicationController
  before_filter :authenticate, only: [:create, :destroy]
  before_filter :authorized_user, only: :destroy
  
  def create
      @micropost = current_user.microposts.build(params[:micropost])
      if @micropost.save
          flash[:success] = "New micropost created."
          redirect_to root_path
        else 
          @feed_items = current_user.feed.paginate(page: params[:page])
          render('pages/home')
      end
  end
  
  def destroy
      @micropost.destroy
      flash[:success] = "Micropost deleted."
      redirect_back_or root_path
  end

  ## GET users/
  def index
    @cur_user = User.find(params[:user_id])
    @title = "All of #{@cur_user.name} posts:"
    @show_gravatar = false
    if signed_in?
        @feed_items = @cur_user.feed.paginate(page: params[:page])
      else
        @feed_items ||= []
    end
  end


  private
    def authorized_user
        @micropost = Micropost.find(params[:id])
        redirect_to root_path unless current_user?(@micropost.user)
    end
end