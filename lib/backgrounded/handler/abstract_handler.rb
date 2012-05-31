module Backgrounded
  module Handler
    class AbstractHandler
      attr_accessor :options

      def options
        self.options || {}
      end
    end
  end
end
