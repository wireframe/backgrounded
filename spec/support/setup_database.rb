config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite'])

ActiveRecord::Schema.define(:version => 1) do
  create_table :blogs, :force => true do |t|
    t.column :title, :string
    t.column :body, :string
  end
  create_table :users, :force => true do |t|
    t.column :name, :string
  end
end
