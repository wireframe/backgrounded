require 'resque'

module Backgrounded
  module Handler
    #enque requests in resque
    class ResqueHandler
      def request(object, method, *args)
        Resque.enqueue(self, object.class.name, object.id, method, *args)
      end
      def queue
        'backgrounded'
      end

      def perform(clazz, id, method, *args)
        clazz.constantize.find(id).send(method, *args)
      end
    end
  end
end
