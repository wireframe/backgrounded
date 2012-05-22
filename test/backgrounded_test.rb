require File.join(File.dirname(__FILE__), 'test_helper')

class BackgroundedTest < Test::Unit::TestCase

  class User
    def do_stuff
    end
    def self.do_something_else
    end
  end

  context '#backgrounded' do
    should 'be defined for class' do
      assert User.respond_to?(:backgrounded)
    end
    should 'be defined for instance' do
      assert User.new.respond_to?(:backgrounded)
    end
    context 'invoking on class' do
      setup do
        @result = User.backgrounded
      end
      should 'return instance of Backgrounded::Proxy' do
        assert @result.is_a?(Backgrounded::Proxy)
      end
    end
    context 'invoking on an instance' do
      setup do
        @user = User.new
        @result = @user.backgrounded
      end
      should 'return instance of Backgrounded::Proxy' do
        assert @result.is_a?(Backgrounded::Proxy)
      end
    end
    context 'invoking with options' do
      setup do
        @result = User.backgrounded(:priority => :high)
      end
      should 'initialize proxy with options' do
        assert_equal({:priority => :high}, @result.instance_variable_get(:@options))
      end
    end
  end
end
