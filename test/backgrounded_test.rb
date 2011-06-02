require File.join(File.dirname(__FILE__), 'test_helper')

class BackgroundedTest < Test::Unit::TestCase
  
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

  class Comment
    backgrounded :delete_spam!

    def delete_spam!
    end
  end

  class Dog
    backgrounded :bark => {:priority => :low}

    def bark
    end
  end

  class Entry
    backgrounded :do_stuff
    backgrounded :notify_users

    def do_stuff
    end
    def notify_users
    end
  end

  class Blog
    class << self
      backgrounded :update_info
      def update_info
      end
    end
  end

  context 'an object with a single backgrounded method' do
    setup do
      @user = User.new
    end
    should 'define backgrounded method' do
      assert @user.respond_to?('do_stuff_backgrounded')
    end
    should 'define backgrounded_options method' do
      assert @user.respond_to?('do_stuff_backgrounded_options')
    end
    should 'save backgrounded options for method' do
      assert_equal({}, @user.do_stuff_backgrounded_options)
    end
    context 'executing backgrounded method' do
      setup do
        @user.expects(:do_stuff).returns(true)
        @result = @user.do_stuff_backgrounded
      end
      should "execute method in background" do end #see expectations
      should 'return nil for backgrounded method' do
        assert_nil @result
      end
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
  
  context 'an object with a backgrounded method included punctuation' do
    setup do
      @comment = Comment.new
    end
    should 'move punctuation to the end of the new method' do
      assert @comment.respond_to?(:'delete_spam_backgrounded!')
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

  context 'an object with multiple backgrounded invokations' do
    setup do
      @post = Entry.new
    end
    should "setup options for both methods" do
      assert_equal({}, @post.do_stuff_backgrounded_options)
      assert_equal({}, @post.notify_users_backgrounded_options)
    end
  end

  context 'an object with backgrounded method options' do
    setup do
      @dog = Dog.new
    end
    should 'save method options for future use' do
      assert_equal({:priority => :low}, @dog.bark_backgrounded_options)
    end
  end

  context 'a class with backgrounded method' do
    should 'define backgrounded method' do
      assert Blog.respond_to?('update_info_backgrounded')
    end
    should 'defined backgrounded_options method' do
      assert Blog.respond_to?('update_info_backgrounded_options')
    end
    should 'save backgrounded options for method' do
      assert_equal({}, Blog.update_info_backgrounded_options)
    end
    context 'invoking backgrounded method' do
      setup do
        Blog.expects(:update_info)
        Blog.update_info_backgrounded
      end
      should 'invoke class method' do end #see expectations
    end
  end
end
