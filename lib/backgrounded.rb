require 'active_support/all'
require 'handler/inprocess_handler'

module Backgrounded
  mattr_accessor :handler
  def self.handler
    @@handler ||= Backgrounded::Handler::InprocessHandler.new
  end

  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def backgrounded(*methods)
        methods.each do |method|
          method_basename, punctuation = method.to_s.sub(/([?!=])$/, ''), $1
          define_method :"#{method_basename}_backgrounded#{punctuation}" do |*args|
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
