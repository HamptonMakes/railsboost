class GemCommand < Command
  def self.default_options
    {:source => "http://gems.github.com"}
  end
end