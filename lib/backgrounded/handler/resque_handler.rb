require 'resque'

module Backgrounded
  module Handler
    #enque requests in resque
    class ResqueHandler
      DEFAULT_QUEUE = 'backgrounded'
      INVALID_ID = -1
      @@queue = DEFAULT_QUEUE

      def request(object, method, args, options={})
        @@queue = options[:queue] || DEFAULT_QUEUE
        instance, id = instance_identifiers(object)
        Resque.enqueue(ResqueHandler, instance, id, method, *args)
      end
      def self.queue
        @@queue
      end
      def self.perform(clazz, id, method, *args)
        find_instance(clazz, id, method).send(method, *args)
      end

      private
      def self.find_instance(clazz, id, method)
        clazz = clazz.constantize
        id.to_i == INVALID_ID ? clazz : clazz.find(id)
      end
      def instance_identifiers(object)
        instance, id = if object.is_a?(Class) 
          [object.name, INVALID_ID]
        else
          [object.class.name, object.id]
        end
      end
    end
  end
end
