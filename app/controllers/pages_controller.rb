class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
        @micropost = Micropost.new 
        @feed_items = current_user.feed.paginate(page: params[:page])
        @show_gravatar = true
    end
  end
 
  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  ###########################
  # RESTful test -- START
  def show
    @title = "RESTful Test: Show Page"
  end

  def index
    @title = "RESTful Test: Index Page"
    @hard_pages = ["contact", "about"]
    @soft_pages = ["mofo", "jojo", "coco"]
  end
  # RESTful test -- END
  ###########################

end
