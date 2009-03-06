require 'test/unit'
require 'lib/radiograph.rb'
require 'lib/radiograph_helper.rb'
require 'test/stubbing'

RAILS_ROOT = "../../../../"


class RadiographTest < Test::Unit::TestCase
  include RadiographHelper
  include StubHelper

  def test_accessor_defaults
    assert_equal 'all_hallows_eve', Radiograph.theme
    assert_equal Radiograph.syntax, 'ruby'
    assert_equal Radiograph.line_numbers, true
  end
  
  def test_setters
    Radiograph.theme = 'dawn'
    assert_equal Radiograph.theme, 'dawn'
    
    Radiograph.syntax = 'ruby_on_rails'
    assert_equal Radiograph.syntax, 'ruby_on_rails'

    Radiograph.line_numbers = false
    assert_equal Radiograph.line_numbers, false
  end
  
  def test_helper
    expects = '<pre class="all_hallows_eve"><span class="line-numbers">   1 </span> puts <span class="String"><span class="String">&quot;</span>Highlight, please!<span class="String">&quot;</span></span>
</pre>'
    assert_equal expects, code('puts "Highlight, please!"', {})

    expects = '<pre class="cobalt"><span class="line-numbers">   1 </span> theme <span class="Keyword">=</span> <span class="Punctuation">&quot;</span>cobalt<span class="Punctuation">&quot;</span>
</pre>'
    assert_equal expects, c('theme = "cobalt"', :theme => 'cobalt')

    expects = '<pre class="all_hallows_eve"><span class="line-numbers">   1 </span> my_syntax <span class="Keyword">=</span> [<span class="String"><span class="String">&quot;</span>ruby<span class="String">&quot;</span></span>, <span class="String"><span class="String">&quot;</span>on<span class="String">&quot;</span></span>, <span class="String"><span class="String">&quot;</span>rails<span class="String">&quot;</span></span>]
</pre>'
    assert_equal expects, code('my_syntax = ["ruby", "on", "rails"]', :syntax => 'ruby_on_rails')

    expects = '<pre class="all_hallows_eve">line numbers.<span class="FunctionName">begone?</span>
<span class="Comment"><span class="Comment">#</span> =&gt; true</span>
</pre>'
    assert_equal expects, c("line numbers.begone?\n# => true", :line_numbers => false)

    expects = '<pre class="eiffel">mega_conglomeration <span class="Keyword">=</span> <span class="Number">42</span>
</pre>'
    assert_equal expects, code("mega_conglomeration = 42", :theme => 'eiffel', :syntax => 'ruby_on_rails', :line_numbers => false)
  end
  
  def test_output
    expects = '<pre class="all_hallows_eve"><span class="line-numbers">   1 </span> puts <span class="String"><span class="String">&quot;</span>Highlight, please!<span class="String">&quot;</span></span>
</pre>'
    assert_equal expects, Radiograph.code('puts "Highlight, please!"', {})
    
    expects = '<pre class="cobalt"><span class="line-numbers">   1 </span> theme <span class="Keyword">=</span> <span class="Punctuation">&quot;</span>cobalt<span class="Punctuation">&quot;</span>
</pre>'
    assert_equal expects, Radiograph.code('theme = "cobalt"', :theme => 'cobalt')
    
    expects = '<pre class="all_hallows_eve"><span class="line-numbers">   1 </span> my_syntax <span class="Keyword">=</span> [<span class="String"><span class="String">&quot;</span>ruby<span class="String">&quot;</span></span>, <span class="String"><span class="String">&quot;</span>on<span class="String">&quot;</span></span>, <span class="String"><span class="String">&quot;</span>rails<span class="String">&quot;</span></span>]
</pre>'
    assert_equal expects, Radiograph.code('my_syntax = ["ruby", "on", "rails"]', :syntax => 'ruby_on_rails')

    expects = '<pre class="all_hallows_eve">line numbers.<span class="FunctionName">begone?</span>
<span class="Comment"><span class="Comment">#</span> =&gt; true</span>
</pre>'
    assert_equal expects, Radiograph.code("line numbers.begone?\n# => true", :line_numbers => false)
    
    expects = '<pre class="eiffel">mega_conglomeration <span class="Keyword">=</span> <span class="Number">42</span>
</pre>'
    assert_equal expects, Radiograph.code("mega_conglomeration = 42", :theme => 'eiffel', :syntax => 'ruby_on_rails', :line_numbers => false)
  end
  
  def test_css
    assert_equal require_syntax_css, '<link href="/stylesheets/syntax/all_hallows_eve.css" media="screen" rel="Stylesheet" type="text/css" />'
    
    assert_equal require_syntax_css('dawn'), '<link href="/stylesheets/syntax/dawn.css" media="screen" rel="Stylesheet" type="text/css" />'
  end
end
