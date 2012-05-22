require 'resque'

# handler that acts like the in process handler but marshalls the arguments
# this simulates how resque encodes/decodes values to/from redis
# useful when passing symbols to arguments and they end up being processed as strings
module Backgrounded
  module Handler
    class PseudoResqueHandler
      def request(object, method, args, options={})
        object.send method, *Resque.decode(Resque.encode(args))
      end
    end
  end
end
