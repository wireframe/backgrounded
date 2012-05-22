module Backgrounded
  module Handler
    # throw requests out the window
    # useful for test environment to avoid any background work
    class NoOpHandler
      def request(object, method, args, options={})
        # do nothing
      end
    end
  end
end
