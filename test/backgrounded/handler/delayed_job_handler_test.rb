require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')
require 'backgrounded/handler/delayed_job_handler'
require 'delayed/backend/active_record'

ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.column :name, :string
  end
  create_table :delayed_jobs, :force => true do |table|
    table.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
    table.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
    table.text     :handler                      # YAML-encoded string of the object that will do work
    table.string   :last_error                   # reason for last failure (See Note below)
    table.datetime :run_at                       # When to run. Could be Time.now for immediately, or sometime in the future.
    table.datetime :locked_at                    # Set when a client is working on this object
    table.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
    table.string   :locked_by                    # Who is working on this object (if locked)
    table.timestamps
  end
end

class DelayedJobHandlerTest < Test::Unit::TestCase

  class User < ActiveRecord::Base
    backgrounded :do_stuff

    def do_stuff
    end
  end

  context 'when backgrounded is configured with delayed_job' do
    setup do
      Delayed::Worker.backend = :active_record
      @handler = Backgrounded::Handler::DelayedJobHandler.new
      Backgrounded.handler = @handler
    end

    should 'be configured' do
      fail 'delayed job not recognizing activerecord config'
    end
    # context 'a persisted object with a single backgrounded method' do
    #   setup do
    #     @user = User.create
    #   end
    #   context "invoking backgrounded method" do
    #     setup do
    #       @user.do_stuff_backgrounded
    #     end
    #     should_create Delayed::Job
    #     should 'create delayed job' do
    #       job = Delayed::Job.last
    #     end
    #   end
    # end
  end
end
