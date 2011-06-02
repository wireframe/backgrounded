require 'active_support/all'

require File.join(File.dirname(__FILE__), 'backgrounded', 'class_methods')
require File.join(File.dirname(__FILE__), 'backgrounded', 'handler', 'inprocess_handler')

Object.send(:include, Backgrounded::ClassMethods)

module Backgrounded
  class << self
    attr_accessor :logger, :handler
  end
end

# default handler to the basic in process handler
Backgrounded.handler = Backgrounded::Handler::InprocessHandler.new

# configure default logger to standard out with info log level
Backgrounded.logger = Logger.new STDOUT
Backgrounded.logger.level = Logger::INFO
