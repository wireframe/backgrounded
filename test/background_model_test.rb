require 'test_helper'

class User
  background_model :do_stuff

  def do_stuff
  end
end

class BackgroundModelTest < Test::Unit::TestCase
  should "execute method in background" do
    user = User.new
    user.expects(:do_stuff)
    user.do_stuff_in_background
  end
end
