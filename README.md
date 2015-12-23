[![Build Status](https://travis-ci.org/wireframe/backgrounded.png?branch=master)](https://travis-ci.org/wireframe/backgrounded)
# Backgrounded

> The cleanest way to integrate background processing into your application.

Backgrounded provides a thin wrapper around any background processing
framework that implements the Backgrounded handler API which makes it
trivial to swap out processing frameworks with no impact to your code.

# Features

* clean and concise API which removes any dependency on external “worker”
jobs and allows you to execute any model method in the background
* integrates with any background processing framework (DelayedJob, Resque,
JobFu, Workling, etc)
* background methods can be actually unit tested by using an "in
process" runner
* custom callbacks to execute ActiveRecord callbacks in the background after
being committed to the database

# General Usage


    class User
      def do_stuff
      end
      def self.do_something_else
      end
    end

    user = User.new
    # execute instance method in background
    user.backgrounded.do_stuff

    # execute class method in background
    User.backgrounded.do_something_else

# after_commit_backgrounded Callback

Automatically execute a callback in the background after a model has been
saved to the database.  All of the standard after_commit options are
available as well as an optional :backgrounded option which will be passed
to the Backgrounded::Handler.

    class User < ActiveRecord::Base
      # execute :do_something in the background after committed
      after_commit_backgrounded :do_something

      # execute :do_something_else in the background after committed
      # passing custom options to the backgrounded handler
      after_commit_backgrounded :do_something_else, :backgrounded => {:priority => :high}
    end

# Installation

   $ gem install backgrounded

# Configuration

Backgrounded handlers are available for popular libraries in separate gems.
Just drop in the gem for your particular framework or write your own!

## Resque

see [github.com/wireframe/backgrounded-resque](http://github.com/wireframe/backgrounded-resque)

## JobFu

see [github.com/jnstq/job_fu/tree](http://github.com/jnstq/job_fu/tree)

## Custom Handlers

Writing a custom handler is as simple as:

    # config/initializers/backgrounded.rb
    class MyHandler
      # @param object is the target object to invoke the method upon
      # @param method is the requested method to call
      # @param args is the optional list of arguments to pass to the method
      # @param options is the optional hash of options passed to the backgrounded call
      def request(object, method, args, options={})
        # process the call however you want!
      end
    end

    # configure backgrounded to use your handler like so:
    Backgrounded.configure do |config|
      config.handler = MyHandler.new
    end

## Copyright

Copyright © 2012 Ryan Sonnek. See LICENSE for details.

