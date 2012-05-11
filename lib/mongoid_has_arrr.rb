Dir[File.expand_path(File.join(File.dirname(__FILE__), 'mongoid', '*.rb'))].each{|stuff| require stuff}
