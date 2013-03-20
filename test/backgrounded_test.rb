require File.join(File.dirname(__FILE__), 'test_helper')

class BackgroundedTest < Test::Unit::TestCase

  class Dog
    def do_stuff
    end
    def self.do_something_else
    end
  end

  context '#backgrounded' do
    should 'be defined for class' do
      assert Dog.respond_to?(:backgrounded)
    end
    should 'be defined for instance' do
      assert Dog.new.respond_to?(:backgrounded)
    end
    context 'invoking on class' do
      setup do
        @result = Dog.backgrounded
      end
      should 'return instance of Backgrounded::Proxy' do
        assert @result.is_a?(Backgrounded::Proxy)
      end
    end
    context 'invoking on an instance' do
      setup do
        @dog = Dog.new
        @result = @dog.backgrounded
      end
      should 'return instance of Backgrounded::Proxy' do
        assert @result.is_a?(Backgrounded::Proxy)
      end
    end
    context 'invoking with options' do
      setup do
        @dog = Dog.new
        Backgrounded.handler.expects(:request).with(@dog, :do_stuff, [], {:priority => :high})
        @dog.backgrounded(:priority => :high).do_stuff
      end
      should 'pass options onto Backgrounded.handler' do end # see expectations
    end
  end
end
