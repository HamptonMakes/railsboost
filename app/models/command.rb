class Command < ActiveRecord::Base
  has_many :dependencies
  has_many :required_commands, :through => :dependencies
  serialize :options, Hash

  def self.default_options
    {}
  end

  def to_ruby(global_options = {})
    return script if script.present?
    return default_script unless description.present?
    "# #{description}\n" + default_script
  end
  
  def display_name
    "#{name} #{category}"
  end

  def category
    self.class.to_s[0..-8].downcase
  end

  def default_script
    @default_script ||= "#{category} '#{name}'#{option_array.join(spacing)}\n"
  end

  def option_array
    if options.present?
      option_array = options.map do |key, value|
        if value.present?
          ":#{key} => #{value.inspect}"
        else
          nil
        end
      end
      [nil] + option_array.compact
    else
      []
    end
  end

  def spacing
    @spacing ||= ", "
  end

end
