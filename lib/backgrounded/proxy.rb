module Backgrounded
  class Proxy
    def initialize(delegate, options={})
      @delegate = delegate
      @options = options
    end

    def method_missing(method_name, *args)
      Backgrounded.logger.debug("Requesting #{Backgrounded.handler} backgrounded method: #{method_name} for instance #{@delegate}")
      Backgrounded.handler.request(@delegate, method_name, args, @options)
      nil
    end
  end
end
