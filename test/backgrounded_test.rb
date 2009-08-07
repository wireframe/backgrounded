require 'test_helper'

class User
  backgrounded :do_stuff

  def do_stuff
  end
end

class Person
  backgrounded :do_stuff

  def do_stuff(name, place, location)
  end
end

class Post
  backgrounded :do_stuff, :notify_users

  def do_stuff
  end
  def notify_users
  end
end

class BackgroundedTest < Test::Unit::TestCase
  context 'an object with a single backgrounded method' do
    setup do
      @user = User.new
    end
    should "execute method in background" do
      @user.expects(:do_stuff)
      @user.do_stuff_backgrounded
    end
  end

  context 'an object with a backgrounded method that accepts parameters' do
    setup do
      @person = Person.new
    end
    should 'forward them' do
      @person.expects(:do_stuff).with('ryan', 2, 3)
      @person.do_stuff_backgrounded('ryan', 2, 3)
    end
  end

  context 'an object with multiple backgrounded methods' do
    setup do
      @post = Post.new
    end
    should "execute method either method in background" do
      @post.expects(:do_stuff)
      @post.do_stuff_backgrounded

      @post.expects(:notify_users)
      @post.notify_users_backgrounded
    end
  end
end
