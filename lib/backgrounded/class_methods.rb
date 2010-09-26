module Backgrounded
  module ClassMethods
    def backgrounded(*methods)
      methods.each do |method|
        method_basename, punctuation = method.to_s.sub(/([?!=])$/, ''), $1
        define_method "#{method_basename}_backgrounded#{punctuation}" do |*args|
          Backgrounded.handler.request(self, method, *args)
        end
      end
    end
  end
end