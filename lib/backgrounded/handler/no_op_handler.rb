require 'backgrounded/handler/abstract_handler'

module Backgrounded
  module Handler
    # throw requests out the window
    # useful for test environment to avoid any background work
    class NoOpHandler < AbstractHandler
      def request(object, method, args)
        # do nothing
      end
    end
  end
end
