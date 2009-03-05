require 'iconv'

class String
  def permalize!
    permalink!(self)
  end
  
  def permalize
    temp_string = self.dup
    permalink!(temp_string)
  end

  def permalink!(word)
    word = Iconv.new('US-ASCII//TRANSLIT', 'utf-8').iconv word
    word.gsub!(/[^\w\s\-\—]/,'')        # remove all non word except for whitespaces and dashes
    word.gsub!(/(\s|_|-)+/, ' ')        # replace all consecutive whitespaces and underscores with a single whitespace
    word.strip!                       # strip leading/trailing whitespace
    word.gsub!('/\s?-\s?/', '-') # remove whitespace surrounding dashs 
    word.gsub!('/(-)+/', '-') # replace all consecutive dashes with a single dash
    word.gsub!(/\s/, '-')             # replace whitespace with hyphen
    word.downcase!                    # downcase bang
    return word                       # return the word
  end  
end