# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def tweet_this
    link_to(image_tag('tweet_this.png', :alt => 'Tweet This!'), "http://twitter.com/home?status=Easy Rails Template Generation at www.railsboost.com!")
  end
end
