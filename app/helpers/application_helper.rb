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

  def character_count(field_id, update_id, options = {frequency: 0.1})
    function = "$('#{update_id}').innerHTML = $F('#{field_id}').length;"
    out = javascript_tag(function) # set current length
    out += observe_field(field_id, options.merge(:function => function)) # and observe it
  end
  
      
end
