module Backgrounded
  module Handler
    #simple handler to process synchronously and not actually in the background
    #useful for testing
    class InprocessHandler
      def request(object, method, args, options={})
        object.send method, *args
      end
    end
  end
end
