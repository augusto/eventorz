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

  end

  describe "event keyword" do
    it "adds obj.event_name reader" do
      @clazz.new.should respond_to(:event_name)
    end

    it "adds private fire_event_name method" do
      @clazz.should have_private_method(:fire_event_name)
    end
  end

  describe "can append event" do
    it "with obj.event += handler" do
      instance = @clazz.new
      instance.event_name += handle
    end
  end
  
end
