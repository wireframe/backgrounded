require 'active_support/concern'
require_relative 'proxy'

module Backgrounded
  # mixin to add backgrounded proxy builder to all ruby objects
  module ObjectExtensions
    extend ActiveSupport::Concern

    # @param options (optional) options to pass into the backgrounded handler
    def backgrounded(options={})
      Backgrounded::Proxy.new self, options
    end

    class_methods do
      # @see Backgrounded::Concern#backgrounded
      def backgrounded(options={})
        Backgrounded::Proxy.new self, options
      end
    end
  end
end
Object.send(:include, Backgrounded::ObjectExtensions)
