RSpec.describe Backgrounded::Proxy do
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
      before do
        @delegate = Person.new
        expect(Backgrounded.handler).to receive(:request).with(@delegate, :do_stuff, ['foo', 1, 'bar'], {:option_one => 'alpha'})
        @proxy = Backgrounded::Proxy.new @delegate, :option_one => 'alpha'
        @result = @proxy.do_stuff 'foo', 1, 'bar'
      end
      it 'invokes Backgrounded.handler with delegate, method and args' do end #see expectations
      it 'return nil' do
        expect(@result).to be_nil
      end
    end
    context 'with arguments' do
      before do
        @delegate = Person.new
        expect(Backgrounded.handler).to receive(:request).with(@delegate, :do_stuff, ['foo', 1, 'bar'], {})
        @proxy = Backgrounded::Proxy.new @delegate
        @result = @proxy.do_stuff 'foo', 1, 'bar'
      end
      it 'invokes Backgrounded.handler with delegate, method and args' do end #see expectations
      it 'return nil' do
        expect(@result).to be_nil
      end
    end
    context 'with no arguments' do
      before do
        @delegate = Person.new
        expect(Backgrounded.handler).to receive(:request).with(@delegate, :do_stuff_without_arguments, [], {})
        @proxy = Backgrounded::Proxy.new @delegate
        @result = @proxy.do_stuff_without_arguments
      end
      it 'invokes Backgrounded.handler with delegate, method and args' do end #see expectations
      it 'return nil' do
        expect(@result).to be_nil
      end
    end
  end
end
