module Backgrounded
  module ClassMethods
    def backgrounded(*args)
      options = args.extract_options!
      methods_with_options = args.inject({}) do |hash, method| hash[method] = {}; hash end
      methods_with_options.merge! options
      methods_with_options.each_pair do |method, options|
        method_basename, punctuation = method.to_s.sub(/([?!=])$/, ''), $1
        backgrounded_method = "#{method_basename}_backgrounded#{punctuation}"
        class_eval do
          define_method backgrounded_method do |*args|
            Backgrounded.logger.debug("Requesting #{Backgrounded.handler} backgrounded method: #{method} for instance #{self}")
            Backgrounded.handler.request(self, method, *args)
            nil
          end
          define_method Backgrounded.method_name_for_backgrounded_options(method) do
            options
          end
        end
      end
    end
  end
end
