require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')
# require 'backgrounded/handler/workling_handler'

ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.column :name, :string
  end
end

class User < ActiveRecord::Base
  backgrounded :do_stuff

  def do_stuff
  end
end

class WorklingHandlerTest < Test::Unit::TestCase
  context 'when backgrounded is configured with workling' do
    setup do
      @handler = Backgrounded::Handler::WorklingHandler.new
      Backgrounded.handler = @handler
    end

    should 'be configured' do
      fail 'plugin not installed'
    end
    # context 'a persisted object with a single backgrounded method' do
    #   setup do
    #     @user = User.create
    #   end
    #   context "invoking backgrounded method" do
    #     setup do
    #       @user.do_stuff_backgrounded
    #     end
    #     should 'invoke workling worker' do
    #       BackgroundedWorker.any_instance.expects(:perform)
    #     end
    #   end
    # end
  end
end
