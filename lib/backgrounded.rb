module Backgrounded
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def backgrounded(method)
      define_method "#{method.to_s}_in_background" do |*args|
        self.send method, *args
      end
      include Backgrounded::InstanceMethods
      extend Backgrounded::SingletonMethods
    end
  end

  module SingletonMethods
  end
  
  module InstanceMethods
  end
end

Object.send(:include, Backgrounded)
