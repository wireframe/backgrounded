require 'backgrounded/handler/abstract_handler'

module Backgrounded
  module Handler
    #simple handler to process synchronously and not actually in the background
    #useful for testing
    class InprocessHandler < AbstractHandler
      def request(object, method, args)
        object.send method, *args
      end
    end
  end
end
