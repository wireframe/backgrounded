require 'active_support/concern'

module Backgrounded
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    module ClassMethods
      # execute a method in the background after the object is committed to the database
      # @option options [Hash] :backgrounded (optional) options to pass into the backgrounded handler
      # @see after_commit
      def after_commit_backgrounded(method_name, options={})
        self.after_commit options.except(:backgrounded) do |instance|
          instance.backgrounded(options[:backgrounded]).send(method_name)
        end
      end
    end
  end
end
