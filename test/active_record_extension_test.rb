require File.join(File.dirname(__FILE__), 'test_helper')

class ActiveRecordExtensionTest < Test::Unit::TestCase

  class Blog < ActiveRecord::Base
    after_commit_backgrounded :do_something_else
    def do_something_else
    end
  end
  class User < ActiveRecord::Base
    after_commit_backgrounded :do_stuff, :backgrounded => {:priority => :high}
    def do_stuff
    end
  end

  context '.after_commit_backgrounded' do
    should 'be defined on ActiveRecord::Base' do
      assert ActiveRecord::Base.respond_to?(:after_commit_backgrounded)
    end
    context 'when using default options' do
      setup do
        @blog = Blog.new
        @blog.expects(:do_something_else)
        @blog.save
      end
      should 'execute callbacks' do end # see expectations
    end
    context 'when callback has :backgrounded options' do
      setup do
        Backgrounded.handler.expects(:request).with(anything, anything, anything, {:priority => :high})
        @user = User.new
        @user.save
      end
      should 'pass options onto the Backgrounded::Handler#request method' do end # see expectations
    end
  end
end
