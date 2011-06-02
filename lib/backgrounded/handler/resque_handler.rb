require 'resque'

module Backgrounded
  module Handler
    #enque requests in resque
    class ResqueHandler
      DEFAULT_QUEUE = 'backgrounded'
      @@queue = DEFAULT_QUEUE

      def request(object, method, *args)
        options = object.send("#{method.to_s.sub(/([?!=])$/, '')}_backgrounded_options")
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
        clazz.respond_to?(method) ? clazz : clazz.find(id)
      end
      def instance_identifiers(object)
        instance, id = if object.is_a?(Class) 
          [object.name, -1]
        else
          [object.class.name, object.id]
        end
      end
    end
  end
end
