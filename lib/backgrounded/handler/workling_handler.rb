class Backgrounded::Handler::WorklingHandler < Workling::Base
  def request(object, method, *args)
    options = {
      :class => object.class.name,
      :id => object.id,
      :method => method,
      :params => args
    }
    Backgrounded::Handler::WorklingHandler.async_perform options
  end
  def perform(options = {})
    options[:class].constantize.find(options[:id]).send(options[:method], *options[:params])
  end
end
