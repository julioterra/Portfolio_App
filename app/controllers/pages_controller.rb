class PagesController < ApplicationController
  def home
    @title = "Home"
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
