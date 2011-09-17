require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ProcHandler " do
  
  EVENT_PARAMETER = { :param => "some param"}
  
  
  before( :each ) do 
    @proc = lambda { |source, parameters| nil }
    @handler = Eventorz::ProcHandler.new( @proc )
    @source = self
  end
  
  it "is built with a target and method" do
    @handler.should be_kind_of Eventorz::ProcHandler
  end
  
  it "is equal if it points to the same proc" do
    handler2 = @handler.clone
    
    @handler.should_not equal handler2
    @handler.should == handler2
  end
  
  it "invokes the method handler with source and parameters" do
    @proc.should_receive(:call).with(@source, EVENT_PARAMETER)  
    
    @handler.fire @source, EVENT_PARAMETER
  end
  
  it "to_s shows class and proc" do
    @handler.to_s.should =~ /Eventorz::ProcHandler:proc=#<.*?>/
  end
  
end
