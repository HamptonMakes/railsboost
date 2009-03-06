class PluginCommand < Command
  
  def self.default_options 
    {:git => "",
     :svn => ""}
  end
  
end