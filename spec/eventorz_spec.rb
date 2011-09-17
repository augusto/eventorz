require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Eventorz" do

  def test_handler
  end

  class TestSourceClass
      event :event_name

      def fire_event(message)
        on_event_name :message => message
      end
  end

  describe "require module" do
    it "adds 'event' keyword in Module" do
      Module.should have_private_method(:event)
    end

    it "adds 'handler' keyword in Kernel to define handlers" do
      Kernel.should have_private_method(:handler)
    end
  end

  describe "event keyword" do
    it "adds method obj.event_name for obj.event += handler" do
      TestSourceClass.new.should respond_to(:event_name)
    end

    it "adds method obj.event_name= for obj.event += handler" do
      TestSourceClass.new.should respond_to(:event_name=)
    end

    it "adds private method on_event_name" do
      TestSourceClass.should have_private_method(:on_event_name)
    end
  end

  it "can remove a handler with obj.event -= handler" do
    source = TestSourceClass.new

    source.event_name += handler(self, :test_handler)
    source.event_name.should contain_event_handler(self, :test_handler)
    
    source.event_name -= handler(self, :test_handler)
    source.event_name.send(:handlers).should be_empty
  end

  describe "can append event with obj.event += handler" do
    
    before :each do
      @source = TestSourceClass.new
    end
    
    it "specifying the target instance" do
      @source.event_name += handler(self, :test_handler)
      
      @source.event_name.should contain_event_handler(self, :test_handler)
    end
    
    it "without specifying the target instance" do
      @source.event_name += handler(:test_handler)
      
      @source.event_name.should contain_event_handler(self, :test_handler)
    end
    
    it "with a lambda" do
      proc = lambda { |source, parameters| nil }
      @source.event_name += handler( proc )
      
      @source.event_name.should contain_proc_event_handler(proc)
    end
    
    it "with a proc" do
      proc = Proc.new { |source, parameters| nil }
      @source.event_name += handler( proc )
      
      @source.event_name.should contain_proc_event_handler(proc)
    end

    it "with a block" do
      @source.event_name.send(:handlers).size.should == 0 #precondition
      
      @source.event_name += handler { nil }
      
      @source.event_name.send(:handlers).size.should == 1
    end

  end
  
  it "raises error if handler parameters are incorrect" do
    clazz = Class.new
    lambda { clazz.send :handler, "string"}.should raise_exception(ArgumentError)
  end

  describe "invokes handlers" do
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

    it "when calling on_event_name" do
      test_handler = TestHandler.new

      source = TestSourceClass.new
      source.event_name += handler(test_handler, :myHandler)
      source.fire_event :event

      test_handler.events.should eql( [[source, {:message => :event}]] )
    end

    it "in order" do
      collector = []
      test_handler_one = TestHandler.new collector
      test_handler_two = TestHandler.new collector

      source = TestSourceClass.new
      source.event_name += handler(test_handler_one, :myHandler)
      source.event_name += handler(test_handler_two, :myHandler)
      source.fire_event :event

      collector.should eql( [ test_handler_one, test_handler_two ] )
    end
    
    it "in order (even proc, block and method handlers)" do
      @collector = []
      test_handler_one = TestHandler.new @collector
      test_handler_two = Proc.new { |source,params| @collector << "proc" }

      source = TestSourceClass.new
      source.event_name += handler(test_handler_one, :myHandler)
      source.event_name += handler(test_handler_two)
      source.event_name += handler { @collector << "block"}
      source.fire_event :event

      @collector.should eql( [ test_handler_one, "proc" , "block"] )
    end
  end
end
