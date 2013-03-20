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
    context 'without options' do
      setup do
        @blog = Blog.new
        Backgrounded.handler.expects(:request).with(@blog, :do_something_else, [], {})
        @blog.save!
      end
      should 'invoke Backgrounded.handler with no options' do end # see expectations
    end
    context 'with options[:backgrounded]' do
      setup do
        @user = User.new
        Backgrounded.handler.expects(:request).with(@user, :do_stuff, [], {:priority => :high})
        @user.save!
      end
      should 'pass options[:backgrounded] to Backgrounded.handler' do end # see expectations
    end
  end
end
