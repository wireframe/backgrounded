require 'active_record/base'

module Backgrounded
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    module ClassMethods
      # execute a method in the background after the object is committed to the database
      # @option options [Hash] :backgrounded (optional) options to pass into the backgrounded handler
      # @see after_commit
      def after_commit_backgrounded(method_name, options={})
        backgrounded_options = options.delete :backgrounded
        after_commit Proc.new {|o| o.backgrounded(backgrounded_options).send(method_name) }, options
      end
    end
  end
end
ActiveRecord::Base.send(:include, Backgrounded::ActiveRecordExtension)
