require File.join(File.dirname(__FILE__), 'test_helper')

class ProxyTest < Test::Unit::TestCase

  class User
    def do_stuff
    end
    def self.do_something_else
    end
  end

  class Person
    def do_stuff(name, place, location)
    end
  end

  context 'invoking delegate method' do
    context 'with arguments' do
      setup do
        @delegate = Person.new
        @delegate.expects(:do_stuff).with('foo', 1, 'bar')
        @proxy = Backgrounded::Proxy.new @delegate
        @result = @proxy.do_stuff 'foo', 1, 'bar'
      end
      should "execute method on delegate" do end #see expectations
      should 'return nil' do
        assert_nil @result
      end
    end
    context 'with no arguments' do
      setup do
        @delegate = User.new
        @delegate.expects(:do_stuff)
        @proxy = Backgrounded::Proxy.new @delegate
        @result = @proxy.do_stuff
      end
      should "execute method on delegate" do end #see expectations
    end
  end
end
