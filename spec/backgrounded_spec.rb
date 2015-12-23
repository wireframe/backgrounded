RSpec.describe Backgrounded do
  describe '.configure' do
    it 'saves configuration' do
      handler = double
      Backgrounded.configure do |config|
        config.handler = handler
      end
      expect(Backgrounded.handler).to eq handler
    end
  end
end
