require 'active_support/all'

require File.join(File.dirname(__FILE__), 'backgrounded', 'handler', 'inprocess_handler')

module Backgrounded
  extend ActiveSupport::Concern
  class << self
    attr_accessor :logger, :handler
    def method_name_for_backgrounded_options(method_name)
      method_basename, punctuation = method_name.to_s.sub(/([?!=])$/, ''), $1
      "#{method_basename}_backgrounded_options"
    end
  end

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

# include backgrounded into any ruby object
Object.send(:include, Backgrounded)

# default handler to the basic in process handler
Backgrounded.handler = Backgrounded::Handler::InprocessHandler.new

# configure default logger to standard out with info log level
Backgrounded.logger = Logger.new STDOUT
Backgrounded.logger.level = Logger::INFO
