require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')
require 'backgrounded/handler/resque_handler'

ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.column :name, :string
  end

  create_table :posts, :force => true do |t|
    t.column :title, :string
  end
end

class ResqueHandlerTest < Test::Unit::TestCase
  class User < ActiveRecord::Base
    backgrounded :do_stuff

    def do_stuff
    end
  end

  class Post < ActiveRecord::Base
    backgrounded :do_stuff => {:queue => 'important'}

    def do_stuff
    end
  end

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
          assert_equal Backgrounded::Handler::ResqueHandler::DEFAULT_QUEUE, Resque.queue_from_class(Backgrounded::Handler::ResqueHandler)
        end
        context "running background job" do
          should "invoke method on user object" do
            User.any_instance.expects(:do_stuff)
            Resque.run!
          end
        end
      end

      context 'a persisted object with backgrounded method with options' do
        setup do
          @post = Post.create
        end
        context "invoking backgrounded method" do
          setup do
            @post.do_stuff_backgrounded
          end
          should "use configured queue" do
            assert_equal 'important', Backgrounded::Handler::ResqueHandler.queue
            assert_equal 'important', Resque.queue_from_class(Backgrounded::Handler::ResqueHandler)
          end
        end
      end
    end
  end
end
