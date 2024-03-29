module MicropostHelper
  
  def wrap(content)
    raw(content.split.map{ |s| wrap_long_string(s) }.join(' '))
  end

  private
  
  def wrap_long_string(text, max_width = 30)
    zero_width_space = ' '
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end
  
end