$:.unshift(File.dirname(__FILE__) + '/../lib')

RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_record/fixtures'
require 'active_support'
require "#{File.dirname(__FILE__)}/../init"


ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
ActiveRecord::Migration.verbose = false

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$:.unshift(Test::Unit::TestCase.fixture_path)

require 'person'
require 'conversation'

module Factory
  extend self

  def create_conversation!(overrides={})
    defaults = {
      :subject => 'This is a test',
      :closed => 'false'
    }

    state = overrides.delete(:state_machine)

    conversation = Conversation.create!(defaults.merge(overrides))
    conversation.update_attribute(:state_machine, state) if state
    conversation
  end

  def create_person!(overrides={})
    defaults = {
      :name => 'packagethief'
    }
    Person.create!(defaults.merge(overrides))
  end
end
