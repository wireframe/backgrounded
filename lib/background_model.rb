module BackgroundModel
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def background_model(method)
      define_method "#{method.to_s}_in_background" do |*args|
        self.send method, *args
      end
      include BackgroundModel::InstanceMethods
      extend BackgroundModel::SingletonMethods
    end
  end

  module SingletonMethods
  end
  
  module InstanceMethods
  end
end

Object.send(:include, BackgroundModel)
