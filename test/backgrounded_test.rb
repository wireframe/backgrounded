require 'test_helper'

class User
  backgrounded :do_stuff

  def do_stuff
  end
end

class BackgroundedTest < Test::Unit::TestCase
  should "execute method in background" do
    user = User.new
    user.expects(:do_stuff)
    user.do_stuff_in_background
  end
end
