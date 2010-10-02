module Backgrounded
  module ClassMethods
    def backgrounded(*args)
      options = args.extract_options!
      methods_with_options = args.inject({}) do |hash, method| hash[method] = {}; hash end
      methods_with_options.merge! options
      methods_with_options.each_pair do |method, options|
        method_basename, punctuation = method.to_s.sub(/([?!=])$/, ''), $1
        define_method "#{method_basename}_backgrounded#{punctuation}" do |*args|
          Backgrounded.handler.request(self, method, *args)
        end
      end
      cattr_accessor :backgrounded_options
      self.backgrounded_options = methods_with_options
    end
  end
end