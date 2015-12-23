RSpec.describe Backgrounded::ObjectExtensions do
  class Dog
    def do_stuff
    end

    def self.do_something_else
    end
  end

  describe '.backgrounded' do
    it 'is defined' do
      expect(Dog).to respond_to(:backgrounded)
    end
    it 'returns instance of Backgrounded::Proxy' do
      @result = Dog.backgrounded
      expect(@result).to be_kind_of(Backgrounded::Proxy)
    end
  end

  describe '#backgrounded' do
    it 'is defined' do
      dog = Dog.new
      expect(dog).to respond_to(:backgrounded)
    end
    it 'return instance of Backgrounded::Proxy' do
      @dog = Dog.new
      @result = @dog.backgrounded
      expect(@result).to be_kind_of(Backgrounded::Proxy)
    end
    context 'invoking with options' do
      before do
        @dog = Dog.new
        expect(Backgrounded.handler).to receive(:request).with(@dog, :do_stuff, [], {:priority => :high})
        @dog.backgrounded(:priority => :high).do_stuff
      end
      it 'pass options onto Backgrounded.handler' do end # see expectations
    end
  end
end
