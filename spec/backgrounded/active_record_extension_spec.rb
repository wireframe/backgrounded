RSpec.describe Backgrounded::ActiveRecordExtension do
  class Blog < ActiveRecord::Base
    include Backgrounded::ActiveRecordExtension
    after_commit_backgrounded :do_something_else
    def do_something_else
    end
  end
  class User < ActiveRecord::Base
    include Backgrounded::ActiveRecordExtension
    after_commit_backgrounded :do_stuff, :backgrounded => {:priority => :high}
    def do_stuff
    end
  end

  describe '.after_commit_backgrounded' do
    context 'without options' do
      before do
        @blog = Blog.new
        expect(Backgrounded.handler).to receive(:request).with(@blog, :do_something_else, [], {})
        @blog.save!
      end
      it 'invoke Backgrounded.handler with no options' do end # see expectations
    end
    context 'with options[:backgrounded]' do
      before do
        @user = User.new
        expect(Backgrounded.handler).to receive(:request).with(@user, :do_stuff, [], {:priority => :high})
        @user.save!
      end
      it 'pass options[:backgrounded] to Backgrounded.handler' do end # see expectations
    end
  end
end
