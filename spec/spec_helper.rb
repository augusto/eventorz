require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'eventorz'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

# Custom Matchers
RSpec::Matchers.define :have_private_method do |method_name|
  match do |clazz|
    clazz.private_method_defined? method_name
  end
  
  failure_message_for_should do |clazz|
    "expected class #{clazz} to have a private method named #{method_name.to_s}"
  end
end

RSpec::Matchers.define :contain_event_handler do |instance, method_name|
  match do |event_handler|
    handlers = event_handler.instance_variable_get("@handlers");
    handlers.include? Eventorz::EventHandler.new(instance, method_name)
  end

  failure_message_for_should do |event_handler|
    "the event handler didn't include the handle for #{instance}.#{method_name}"
  end
end

