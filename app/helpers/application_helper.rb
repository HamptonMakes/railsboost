# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def tweet_this
    link_to(image_tag('tweet_this.png', :alt => 'Tweet This!'), "http://twitter.com/home?status=Easy Rails Template Generation at www.railsboost.com!")
  end
  
  def delicious_this
    link_to(image_tag('delicious_this.png', :alt => 'Del.icio.us'), "http://del.icio.us/post?v=2&url=www.railsboost.com&title=Rails Boost: Rails Template Generator")
  end
  
  def digg_this
    link_to(image_tag('digg_this.png', :alt => 'Digg This!'), "http://digg.com/submit?phase=2&url=www.railsboost.com")
  end
end
