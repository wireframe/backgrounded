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

    # passes the job to bj by serializing the options and invoking the object's method through script/runner
    # see http://github.com/github/bj/tree/master
    class BackgroundJobHandler
      require 'bj'
      def request(object, method)
        Bj.submit "./script/runner #{object.class}.find(#{object.id}).#{method}"
      end
    end
    
    # use amqp client (bunny) to publish requests
    # see http://github.com/celldee/bunny/tree/master
    class BunnyQueueHandler
      require 'bunny'
      def initialize(queue)
        @queue = queue
      end
      def request(object, method)
        hash = {:object => object.class, :id => object.id, :method => method}
        @queue.publish(YAML::dump(hash), :persistent => true)
      end

      # poll for new requests on the queue
      def poll
        value = @queue.pop
        value == :queue_empty ? nil : YAML::load(value)
        value[:object].constantize.find(value[:id]).send(value[:method]) if value
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
          define_method "#{method.to_s}_in_background" do
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
