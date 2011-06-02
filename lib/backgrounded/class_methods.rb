module Backgrounded
  module ClassMethods
    def backgrounded(*args)
      options = args.extract_options!
      methods_with_options = args.inject({}) do |hash, method| hash[method] = {}; hash end
      methods_with_options.merge! options
      methods_with_options.each_pair do |method, options|
        method_basename, punctuation = method.to_s.sub(/([?!=])$/, ''), $1
        backgrounded_method = "#{method_basename}_backgrounded#{punctuation}"
        backgrounded_options_method = "#{method_basename}_backgrounded_options"
        class_eval do
          define_method backgrounded_method do |*args|
            Backgrounded.logger.debug("Requesting #{Backgrounded.handler} backgrounded method: #{method} for instance #{self}")
            Backgrounded.handler.request(self, method, *args)
            nil
          end
          define_method backgrounded_options_method do
            options
          end
        end
      end
    end
  end
end
