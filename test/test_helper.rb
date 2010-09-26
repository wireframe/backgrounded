require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'active_record'
require 'resque_unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'backgrounded'

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite'])

class Test::Unit::TestCase
end
