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
      def request(object, method, *args)
        object.send method, *args
      end
    end

    # passes the job to bj by serializing the options and invoking the object's method through script/runner
    # see http://github.com/github/bj/tree/master
    class BackgroundJobHandler
      require 'bj'
      def run(object, method, *args)
        #TODO: howto marshall args to the command line?
        Bj.submit "./script/runner #{object.class}.find(#{object.id}).#{method}(#{*args})"
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
          define_method "#{method.to_s}_in_background" do |*args|
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
