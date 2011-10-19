module ApplicationHelper
  
  def title
    base_title = "Welcome to my Rails app"
    if @title
      "#{base_title}, this is the page: #{@title}"
    else
      "#{base_title}, this is a title-less page"
    end    
  end
  
end
