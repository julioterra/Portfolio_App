module UsersHelper
  
  def gravatar_for(user, options = {:size => 50}) 
    gravatar_image_tag user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options
  
  end

  def feed_list_show_gravatar?
    if (@show_gravatar) ; return true 
    else ; return false ; end
  end

end
