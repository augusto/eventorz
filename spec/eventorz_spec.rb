require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'eventorz'

class TestHandler
  attr_accessor :times_executed

  def myHandler
    self.times_executed ||= 0
    self.times_executed += 1
  end

end

describe "Eventorz" do

  before :all do
    @clazz=Class.new(Object) do
      event :event_name

      define_method :fire_event do
        on_event_name
      end
    end
  end

  describe "require module" do
    it "adds 'event' keyword in Module" do
      Module.should have_private_method(:event)
    end

    it "adds 'handle' keyword in Kernel to define handlers" do
      Kernel.should have_private_method(:handle)
    end
  end

  describe "event keyword" do
    it "adds method obj.event_name for obj.event += handler" do
      @clazz.new.should respond_to(:event_name)
    end

    it "adds method obj.event_name= for obj.event += handler" do
      @clazz.new.should respond_to(:event_name=)
    end

    it "adds private method on_event_name" do
      @clazz.should have_private_method(:on_event_name)
    end
  end

  describe "can append event" do
    it "with obj.event += handler" do
      def test_handler
        puts "handling event"
      end

      instance = @clazz.new
      instance.event_name += handle(self, :test_handler)
      instance.event_name.should contain_event_handler(self, :test_handler)
    end
  end

  describe "invokes handlers" do
    it "when calling on_event_name" do
      test_handler = TestHandler.new

      instance = @clazz.new
      instance.event_name += handle(test_handler, :myHandler)
      instance.fire_event

      test_handler.times_executed.should == 1
    end
  end
end
