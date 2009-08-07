require 'activesupport'

module Backgrounded
  module Handler
    Dir["#{File.dirname(__FILE__)}/#{name.demodulize.underscore}/*.rb"].each do |handler_file|
      handler_name = File.basename(handler_file, '.rb').camelize.to_sym
      autoload handler_name, File.expand_path(handler_file)
    end
  end
end