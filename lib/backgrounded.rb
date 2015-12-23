require_relative 'backgrounded/handler/inprocess_handler'
require_relative 'backgrounded/concern'
require_relative 'backgrounded/active_record_extension'

module Backgrounded
  class << self
    attr_accessor :logger, :handler

    def configure
      yield configuration
    end

    def configuration
      self
    end
  end
end

# default library configuration
Backgrounded.configure do |config|
  # default handler to the basic in process handler
  config.handler = Backgrounded::Handler::InprocessHandler.new

  # configure default logger to standard out with info log level
  logger = Logger.new(STDOUT)
  loggerl.evel = Logger::INFO
  config.logger = logger
end
