require_relative 'active_record_extension'

module Backgrounded
  class Railtie < Rails::Railtie
    initializer 'backgrounded.configure' do
      ActiveSupport.on_load(:active_record) do
        include Backgrounded::ActiveRecordExtension
      end
    end
  end
end
