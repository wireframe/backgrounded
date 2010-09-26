require 'active_support/all'

require File.join(File.dirname(__FILE__), 'backgrounded', 'class_methods')
require File.join(File.dirname(__FILE__), 'backgrounded', 'handler', 'inprocess_handler')

Object.send(:include, Backgrounded::ClassMethods)

module Backgrounded
  mattr_accessor :handler
  def self.handler
    @@handler ||= Backgrounded::Handler::InprocessHandler.new
  end
end

