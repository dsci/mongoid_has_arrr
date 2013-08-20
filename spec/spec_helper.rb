$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'

require 'active_record'
require 'sqlite3'
require 'mongoid'
require 'mongoid_has_arrr'

DB_PATH = File.join(File.dirname(__FILE__), "db")

db = SQLite3::Database.new("#{DB_PATH}/test.db")

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "#{DB_PATH}/test.sqlite3"
)

begin
  ActiveRecord::Migration.create_table :authors do |t|
    t.string :name
  end
rescue

end

begin
  ActiveRecord::Migration.create_table :labels do |t|
    t.string :identifier
  end
rescue

end

begin
  ActiveRecord::Migration.create_table :cities do |t|
    t.string :name
  end
rescue

end

begin
  ActiveRecord::Migration.create_table :publishers do |t|
    t.string  :name
    t.string  :book_id
  end
rescue
end

begin
  ActiveRecord::Migration.create_table :editors do |t|
    t.integer :edited_book_id
    t.string  :name
  end
rescue
end

begin
  ActiveRecord::Migration.create_table :prices do |t|
    t.float   :value
    t.string  :book_id
  end
rescue
end

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("ar_test")
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end
