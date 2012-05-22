require 'active_support/all'

require File.join(File.dirname(__FILE__), 'backgrounded', 'handler', 'inprocess_handler')
require File.join(File.dirname(__FILE__), 'backgrounded', 'proxy')

module Backgrounded
  extend ActiveSupport::Concern

  class << self
    attr_accessor :logger, :handler
  end

  module ClassMethods
    def backgrounded(options={})
      Backgrounded::Proxy.new self, options
    end
  end

  # @param options (optional) options to pass into the backgrounded handler
  def backgrounded(options={})
    Backgrounded::Proxy.new self, options
  end
end

# include backgrounded into any ruby object
Object.send(:include, Backgrounded)

# default handler to the basic in process handler
Backgrounded.handler = Backgrounded::Handler::InprocessHandler.new

# configure default logger to standard out with info log level
Backgrounded.logger = Logger.new STDOUT
Backgrounded.logger.level = Logger::INFO
