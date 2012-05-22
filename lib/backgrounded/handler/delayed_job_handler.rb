require 'delayed_job'

module Backgrounded
  module Handler
    # invoke the operation in the background using delayed job
    # see http://github.com/tobi/delayed_job/tree/master
    class DelayedJobHandler
      def request(object, method, args, options={})
        object.send_later(method.to_sym, *args)
      end
    end
  end
end
