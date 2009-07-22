require 'activesupport'

module Backgrounded
  mattr_accessor :handler
  def self.handler
    @@handler ||= Backgrounded::Handler::InprocessHandler.new
  end
  module Handler
    #simple handler to process synchronously and not actually in the background
    #useful for testing
    class InprocessHandler
      def request(object, method)
        object.send method
      end
    end

    # invoke the operation in the background using delayed job
    # see http://github.com/tobi/delayed_job/tree/master
    class DelayedJobHandler
      require 'delayed_job'
      def request(object, method)
        object.send_later(method.to_sym)
      end
    end
  end

  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def backgrounded(*methods)
        methods.each do |method|
          define_method "#{method.to_s}_backgrounded" do
            Backgrounded.handler.request(self, method)
          end
        end
        include Backgrounded::Model::InstanceMethods
        extend Backgrounded::Model::SingletonMethods
      end
    end

    module SingletonMethods
    end
  
    module InstanceMethods
    end
  end
end

Object.send(:include, Backgrounded::Model)
