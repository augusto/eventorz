$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'eventorz'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end


RSpec::Matchers.define :have_private_method do |method|
  match do |clazz|
    clazz.private_method_defined? method
  end
  
  failure_message_for_should do |clazz|
    "expected class #{clazz} to have a private method named #{method.to_s}"
  end
end
