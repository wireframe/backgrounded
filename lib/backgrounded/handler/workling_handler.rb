class Backgrounded::Handler::WorklingHandler
  def request(object, method, *args)
    options = {
      :class => object.class.name,
      :id => object.id,
      :method => method,
      :params => args
    }
    BackgroundedWorker.async_perform options
  end

  class BackgroundedWorker < Workling::Base
    def perform(options = {})
      options[:class].constantize.find(options[:id]).send(options[:method], *options[:params])
    end
  end
end
