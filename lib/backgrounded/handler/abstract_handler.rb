module Backgrounded
  module Handler
    class AbstractHandler
      attr_writer :options

      def options
        @options ||= {}
      end
    end
  end
end
