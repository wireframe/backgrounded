require 'activesupport'

module Backgrounded
  mattr_accessor :handler
  def self.handler
    @@handler ||= Backgrounded::Handler::InprocessHandler.new
  end
  
  autoload :Handler, 'handler'
        
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def backgrounded(*methods)
        methods.each do |method|
          define_method "#{method.to_s}_backgrounded" do |*args|
            Backgrounded.handler.request(self, method, *args)
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
