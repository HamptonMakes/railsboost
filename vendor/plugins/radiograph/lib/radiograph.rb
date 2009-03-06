begin
  require 'rubygems'
  require 'uv'
rescue
  raise "You need to have RubyGems (http://www.rubygems.org/) and Ultraviolet (http://ultraviolet.rubyforge.org/) installed to use the Radiograph plugin."
end

# A class to expose Ultraviolet (http://ultraviolet.rubyforge.org/) to
# a Rails application.  The class is primarily used to hold configuration
# values; RadiographHelper is where the methods are exposed at.
class Radiograph

  @@syntax = 'ruby'
  @@theme = 'all_hallows_eve'
  @@line_numbers = true
  
  # TODO: Figure out attr_accessor at the class level or at least refactor this so it's not so copy and paste
  
  # Set the default syntax.
  def Radiograph.syntax=(val)
    @@syntax = val
  end
  
  # Get the current default syntax.
  def Radiograph.syntax
    @@syntax
  end
  
  # Set the default theme.
  def Radiograph.theme=(val)
    @@theme = val
  end
  
  # Get the current default theme.
  def Radiograph.theme
    @@theme
  end
  
  # Toggle line numbers on the output.
  def Radiograph.line_numbers=(val)
    @@line_numbers = val
  end
  
  # Get the status of line numbers on the output.
  def Radiograph.line_numbers
    @@line_numbers
  end
  
  # Copy the CSS files from the gem to the proper place in your Rails application so they can be used.
  def Radiograph.copy_files
    Uv.copy_files "xhtml", "#{RAILS_ROOT}/public/stylesheets"
    File.rename "#{RAILS_ROOT}/public/stylesheets/css/", "#{RAILS_ROOT}/public/stylesheets/syntax/"
  end
  
  # Main method that passes the code off to Ultraviolet.
  def Radiograph.code(code, opts)
    # Are the CSS files present?
    Radiograph.copy_files unless File.exist?("#{RAILS_ROOT}/public/stylesheets/syntax")
     
    Uv.parse(code, "xhtml", opts[:syntax] || @@syntax, ((opts[:line_numbers] == false) ? false : true), opts[:theme] || @@theme)
  end
end