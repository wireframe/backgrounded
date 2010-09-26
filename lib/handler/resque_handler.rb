require 'resque'

module Backgrounded
  module Handler
    #enque requests in resque
    class ResqueHandler

      def self.perform(clazz, id, method, *args)
        clazz.find(id).send(method, *args)
      end

      def request(object, method, *args)
        Resque.enqueue(self, object.class.name, object.id, method, *args)
      end
    end
  end
end
