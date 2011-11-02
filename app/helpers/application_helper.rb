module ApplicationHelper
  
  def title
      base_title = "Portfolios"
      if @title
          "#{base_title} | #{@title}"
      else
          "#{base_title}"
      end    
  end

  def button_title
      base_title = "Submit"
      if @button_title
          "#{@button_title}"
      else
          "{base_title}"
      end
  end
  
end
