module Backgrounded
  class Proxy
    def initialize(delegate)
      @delegate = delegate
    end

    def method_missing(method_name, *args)
      Backgrounded.logger.debug("Requesting #{Backgrounded.handler} backgrounded method: #{method_name} for instance #{@delegate}")
      Backgrounded.handler.request(@delegate, method_name, args)
      nil
    end
  end
end
