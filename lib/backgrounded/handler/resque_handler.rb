require 'resque'

module Backgrounded
  module Handler
    #enque requests in resque
    class ResqueHandler
      DEFAULT_QUEUE = 'backgrounded'
      @@queue = DEFAULT_QUEUE

      def request(object, method, *args)
        @@queue = object.backgrounded_options[method.to_sym][:queue] || DEFAULT_QUEUE
        Resque.enqueue(ResqueHandler, object.class.name, object.id, method, *args)
      end
      def self.queue
        @@queue
      end
      def self.perform(clazz, id, method, *args)
        clazz.constantize.find(id).send(method, *args)
      end
    end
  end
end
