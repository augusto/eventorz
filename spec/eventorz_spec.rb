require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'eventorz'

describe "Eventorz" do

  before :all do
    @clazz=Class.new(Object) do
      event :event_name
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
    it "adds obj.event_name reader" do
      @clazz.new.should respond_to(:event_name)
    end

    it "adds private fire_event_name method" do
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

end
