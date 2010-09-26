require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'handler/resque_handler'

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

class BackgroundedTest < Test::Unit::TestCase
  context 'when backgrounded is configured with resque' do
    setup do
      #run redis-server /usr/local/etc/redis.conf
      # Resque.redis = 'localhost:6379'
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
          assert_queued @handler
        end
        context "running background job" do
          should "invoke method on user object" do
            User.any_instance.expects(:do_stuff)
            Resque.run!
        
            # worker = Resque::Worker.new('backgrounded')
            # worker.verbose = true
            # worker.very_verbose = true
            # worker.log "Starting worker #{worker}"
            # worker.work(1)
          end
        end
      end
    end
  end
end
