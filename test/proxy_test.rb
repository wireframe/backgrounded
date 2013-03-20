require File.join(File.dirname(__FILE__), 'test_helper')

class ProxyTest < Test::Unit::TestCase
  class Person
    def self.do_something_else
    end
    def do_stuff(name, place, location)
    end
    def do_stuff_without_arguments
    end
  end

  context 'invoking delegate method' do
    context 'with arguments and options' do
      setup do
        @delegate = Person.new
        Backgrounded.handler.expects(:request).with(@delegate, :do_stuff, ['foo', 1, 'bar'], {:option_one => 'alpha'})
        @proxy = Backgrounded::Proxy.new @delegate, :option_one => 'alpha'
        @result = @proxy.do_stuff 'foo', 1, 'bar'
      end
      should "invokes Backgrounded.handler with delegate, method and args" do end #see expectations
      should 'return nil' do
        assert_nil @result
      end
    end
    context 'with arguments' do
      setup do
        @delegate = Person.new
        Backgrounded.handler.expects(:request).with(@delegate, :do_stuff, ['foo', 1, 'bar'], {})
        @proxy = Backgrounded::Proxy.new @delegate
        @result = @proxy.do_stuff 'foo', 1, 'bar'
      end
      should "invokes Backgrounded.handler with delegate, method and args" do end #see expectations
      should 'return nil' do
        assert_nil @result
      end
    end
    context 'with no arguments' do
      setup do
        @delegate = Person.new
        Backgrounded.handler.expects(:request).with(@delegate, :do_stuff_without_arguments, [], {})
        @proxy = Backgrounded::Proxy.new @delegate
        @result = @proxy.do_stuff_without_arguments
      end
      should "invokes Backgrounded.handler with delegate, method and args" do end #see expectations
      should 'return nil' do
        assert_nil @result
      end
    end
  end
end
