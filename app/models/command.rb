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

  def category
    self.class.to_s[0..-8].downcase
  end

  def default_script
    @default_script ||= "#{category} '#{name}'#{option_array.join(spacing)}\n"
  end

  def option_array
    returning [] do |option_array|

      if options.present?

        option_array = options.collect do |key, value|
          ":#{key} => #{value.inspect}" if value.present?
        end

        option_array = [nil] + option_array.compact
      end

    end
  end

  def spacing
    @spacing ||= ",\n" + (" " * (category.size + 1))
  end

end
