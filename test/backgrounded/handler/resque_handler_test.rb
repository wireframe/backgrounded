require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')
require 'backgrounded/handler/resque_handler'

ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.column :name, :string
  end
end

class User < ActiveRecord::Base
  backgrounded :do_stuff

  def do_stuff
  end
end

class ResqueHandlerTest < Test::Unit::TestCase
  context 'when backgrounded is configured with resque' do
    setup do
      Resque.reset!
      @handler = Backgrounded::Handler::ResqueHandler.new
      Backgrounded.handler = @handler
    end

    context 'a persisted object with a single backgrounded method' do
      setup do
        @user = User.create
      end
      context "invoking backgrounded method" do
        setup do
          @user.do_stuff_backgrounded
        end
        should "enqueue job to resque" do
          assert_queued Backgrounded::Handler::ResqueHandler
        end
        context "running background job" do
          should "invoke method on user object" do
            User.any_instance.expects(:do_stuff)
            Resque.run!
          end
        end
      end
    end
  end
end
