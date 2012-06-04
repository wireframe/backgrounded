require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')
require 'backgrounded/handler/resque_handler'
require 'resque_unit'

ActiveRecord::Schema.define(:version => 1) do
  create_table :blogs, :force => true do |t|
    t.column :name, :string
  end

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

  class Blog < ActiveRecord::Base
    class << self
      backgrounded :do_stuff

      def do_stuff
      end
    end
    backgrounded :do_stuff
    def do_stuff
    end
  end

  module Foo
    class << self
      backgrounded :bar
      def bar
      end
    end
  end

  context 'when backgrounded is configured with resque' do
    setup do
      Resque.reset!
      @handler = Backgrounded::Handler::ResqueHandler.new
      Backgrounded.handler = @handler
    end

    context 'a class level backgrounded method' do
      context "invoking backgrounded method" do
        setup do
          Blog.do_stuff_backgrounded
        end
        should "enqueue job to resque" do
          assert_queued Backgrounded::Handler::ResqueHandler, [Blog.to_s, -1, 'do_stuff']
          assert_equal Backgrounded::Handler::ResqueHandler::DEFAULT_QUEUE, Resque.queue_from_class(Backgrounded::Handler::ResqueHandler)
        end
        context "running background job" do
          setup do
            Blog.expects(:do_stuff)
            Resque.run!
          end
          should "invoke method on class" do end #see expectations
        end
      end
      context 'with an instance level backgrounded method of the same name' do
        setup do
          @blog = Blog.create
          @blog.do_stuff_backgrounded
        end
        should "enqueue instance method job to resque" do
          assert_queued Backgrounded::Handler::ResqueHandler, [Blog.to_s, @blog.id, 'do_stuff']
          assert_equal Backgrounded::Handler::ResqueHandler::DEFAULT_QUEUE, Resque.queue_from_class(Backgrounded::Handler::ResqueHandler)
        end
        context "running background job" do
          setup do
            Blog.expects(:do_stuff).never
            Blog.any_instance.expects(:do_stuff)
            Resque.run!
          end
          should "invoke method on instance" do end #see expectations
        end
      end
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
          assert_queued Backgrounded::Handler::ResqueHandler, [User.to_s, @user.id, 'do_stuff']
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
            assert_equal 1, Resque.queue('important').length
          end
        end
      end
    end

    context 'with a module backgrounded class method' do
      context 'when invoking class method backgrounded' do
        setup do
          Foo.bar_backgrounded
        end
        should "enqueue job to resque" do
          assert_queued Backgrounded::Resque::ResqueHandler, [Foo.to_s, -1, 'bar']
          assert_equal Backgrounded::Resque::ResqueHandler::DEFAULT_QUEUE, Resque.queue_from_class(Backgrounded::Resque::ResqueHandler)
        end
        context 'when processing job' do
          setup do
            Foo.expects(:bar)
            Resque.run!
          end
          should 'invoke module class method backgrounded' do end # see expectations
        end
      end
    end
  end
end
