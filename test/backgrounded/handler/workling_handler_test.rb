require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')
# RAILS_DEFAULT_LOGGER = Logger.new STDOUT
# RAILS_ENV = 'test'
# require 'newrelic_rpm'
# require 'memcache'
# require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'socialcast', 'vendor', 'plugins', 'workling', 'lib', 'workling')
# require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'socialcast', 'vendor', 'plugins', 'workling', 'lib', 'workling', 'base')
# require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'socialcast', 'vendor', 'plugins', 'workling', 'lib', 'workling', 'discovery')
# require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'socialcast', 'vendor', 'plugins', 'workling', 'lib', 'workling', 'routing', 'class_and_method_routing')
# require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'socialcast', 'vendor', 'plugins', 'workling', 'lib', 'workling', 'remote', 'invokers', 'threaded_poller')
# require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'socialcast', 'vendor', 'plugins', 'workling', 'lib', 'workling', 'remote')
# require 'backgrounded/handler/workling_handler'

ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.column :name, :string
  end
end

class WorklingHandlerTest < Test::Unit::TestCase

  class User < ActiveRecord::Base
    backgrounded :do_stuff

    def do_stuff
    end
  end

  class Post < ActiveRecord::Base
    class << self
      backgrounded :do_stuff

      def do_stuff
      end
    end
  end

  context 'when backgrounded is configured with workling' do
    setup do
      fail 'workling not available as a gem'
      @handler = Backgrounded::Handler::WorklingHandler.new
      Backgrounded.handler = @handler
    end

    context 'a persisted object with a single backgrounded method' do
      setup do
        @user = User.create
      end
      context "invoking backgrounded method" do
        setup do
          User.any_instance.expects(:do_stuff).with('a string')
          @user.do_stuff_backgrounded 'a string'
        end
        should 'dispatch through workling back to the object' do end #see expectations
      end
    end

    context 'a class level backgrounded method' do
      context "invoking backgrounded method" do
        setup do
          Post.expects(:do_stuff).with('a string')
          Post.do_stuff_backgrounded 'a string'
        end
        should 'dispatch through workling back to the object' do end #see expectations
      end
    end
  end
end
