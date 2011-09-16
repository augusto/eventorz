require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class TestHandler
  attr_reader :events
  attr_reader :collector

  def initialize(collector = [])
    @collector = collector
  end

  def myHandler(source, parameters)
    @events ||= []
    @events << [source, parameters]
    @collector << self
  end
end



describe "Eventorz" do

  before :all do
    @clazz=Class.new(Object) do
      event :event_name

      define_method :fire_event do |message|
        on_event_name :message => message
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

  describe "can append event with obj.event += handler" do
    
    before :all do
      def test_handler
        puts "handling event"
      end

      @instance = @clazz.new
    end
    
    it "specifying the target instance" do
      @instance.event_name += handle(self, :test_handler)
      
      @instance.event_name.should contain_event_handler(self, :test_handler)
    end
    
    it "without specifying the target instance" do
      @instance.event_name += handle(:test_handler)
      
      @instance.event_name.should contain_event_handler(self, :test_handler)
    end

  end

  describe "invokes handlers" do
    it "when calling on_event_name" do
      test_handler = TestHandler.new

      instance = @clazz.new
      instance.event_name += handle(test_handler, :myHandler)
      instance.fire_event :event

      test_handler.events.should eql( [[instance, {:message => :event}]] )
    end
    
    it "in order" do
      collector = []
      test_handler_one = TestHandler.new collector
      test_handler_two = TestHandler.new collector

      instance = @clazz.new
      instance.event_name += handle(test_handler_one, :myHandler)
      instance.event_name += handle(test_handler_two, :myHandler)
      instance.fire_event :event

      collector.should eql( [ test_handler_one, test_handler_two ] )
    end
  end
end
