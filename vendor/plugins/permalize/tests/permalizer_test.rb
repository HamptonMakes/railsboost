require 'test/unit'
require '../lib/permalizer'

class PermalizerTest < Test::Unit::TestCase
  
  String.class_eval do
    include Permalizer
  end

  def test_should_return_valid_permalink_with_spaces
    assert_equal "this-is-my-permalink", "this is my permalink".permalize
    assert_equal "another-space-test", "another   space  test".permalize
  end
  
  def test_should_return_valid_permalink_without_spaces
    assert_equal "today", "today".permalize
    assert_equal "bobs", "bob's".permalize
  end

  def test_should_return_valid_permalink_with_spaces_and_apostrophes
    assert_equal "ive-heard-you", "i've heard you".permalize
    assert_equal "double-quotes", "\"double quotes\"".permalize
    assert_equal "single-quotes", "\'single quotes\'".permalize
    assert_equal "multiple-double-quotes", "\"\"multiple double quotes\"\"".permalize
    assert_equal "multiple-single-quotes", "\'\'multiple single quotes\'\'".permalize
    assert_equal "both-single-double-quotes", "\"\'both single double quotes\'\"".permalize
  end
  
  def test_should_return_valid_permalink_with_special_characters
    assert_equal "here-we-are", "here_we are".permalize
    assert_equal "here-we-are-underscores", "here__we___are underscores".permalize
    assert_equal "unicode-character", "unicode chåracter".permalize
    assert_equal "astericks-here", "astericks * here".permalize
    assert_equal "colon-and-semicolon", "colon : and ; semicolon".permalize
    assert_equal "ampersand", "ampersand&".permalize
    assert_equal "here", "here!".permalize
  end
  
  def test_should_return_valid_permalink_with_numerous_types_of_characters
    assert_equal "numerous-characters", "numerous' * characters".permalize
  end
  
  def test_should_return_lower_case
    assert_equal "cool-new-site", "Cool New Site!".permalize
    assert_equal "cool-new-site", "Cool New site!!!".permalize
  end
  
  def test_should_keep_dashes_in_tact
    assert_equal "keep-my-dash", "Keep-My Dash".permalize
    assert_equal "keep-my-dashes", "Keep-my-Dashes".permalize
  end
  
  def test_should_keep_dashes_and_spaces
    assert_equal "dont-forget-dashes-with-spaces", "Dont forget - dashes -- with  --  spaces".permalize 
  end
  
  ####################
  ## with the bang
  ####################
  def test_should_return_valid_permalink_with_spaces_with_bang
    string1 = "this is my permalink"
    string2 = "another   space  test"
    assert_equal "this-is-my-permalink", string1.permalize!
    assert_equal "another-space-test", string2.permalize!
  end
  
  def test_should_return_valid_permalink_without_spaces_with_bang
    string1 = "today"
    string2 = "bob's"
    assert_equal "today", string1.permalize!
    assert_equal "bobs", string2.permalize!
  end

  def test_should_return_valid_permalink_with_spaces_and_apostrophes_with_bang
    assert_equal "ive-heard-you", "i've heard you".permalize!
    assert_equal "double-quotes", "\"double quotes\"".permalize!
    assert_equal "single-quotes", "\'single quotes\'".permalize!
    assert_equal "multiple-double-quotes", "\"\"multiple double quotes\"\"".permalize!
    assert_equal "multiple-single-quotes", "\'\'multiple single quotes\'\'".permalize!
    assert_equal "both-single-double-quotes", "\"\'both single double quotes\'\"".permalize!
  end
  
  def test_should_return_valid_permalink_with_special_characters_with_bang
    assert_equal "here-we-are", "here_we are".permalize!
    assert_equal "here-we-are-underscore", "here__we___are underscore".permalize!
    assert_equal "unicode-character", "unicode chåracter".permalize!
    assert_equal "astericks-here", "astericks * here".permalize!
    assert_equal "colon-and-semicolon", "colon : and ; semicolon".permalize!
    assert_equal "ampersand", "ampersand&".permalize!
    assert_equal "here", "here!".permalize!
  end
  
  def test_should_return_valid_permalink_with_numerous_types_of_characters_with_bang
    assert_equal "numerous-characters", "numerous' * characters".permalize!
  end
  
  def test_should_return_lower_case_with_bang
    assert_equal "cool-new-site", "Cool New Site!".permalize!
    assert_equal "cool-new-site", "Cool New site!!!".permalize!
  end
  
  def test_should_return_exact_with_bang
    string1 = "Cool New stuff_here!!"
    string1.permalize!
    assert_equal "cool-new-stuff-here", string1
  end

end
