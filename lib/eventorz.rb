
module Eventorz
  class EventHandler
  
    public
    def +(handler)
      handlers << handler
    end

    private
    def handlers
      @handlers ||= []
    end
  end

  class InvocationWrapper
    def initialize(instance, method_name)
      @instance = instance
      @method_name = method_name
    end

    def ==(other)
      return false unless other.respond_to?(:instance) and other.respond_to?(:method_name)
      self.instance == other.instance and self.method_name == other.method_name
    end

    protected
    attr_accessor :instance, :method_name;

    public 
    def to_s
      "#{self.class}:instance=#{self.instance};method=#{self.method_name}"
    end
  end

end

class Module
  
  private
  
  def event(event_name)
    method_name = "on_#{event_name}"
    variable_name = "@event_#{event_name}"

    define_method method_name do
    end
    
    define_method event_name do
      var = instance_variable_get(variable_name)
      unless var
        var = Eventorz::EventHandler.new
        instance_variable_set(variable_name, var)
      end
      var
    end

    define_method "#{event_name}=" do |event_handler|

    end

    private method_name.to_sym
  end
end

module Kernel
  private

  def handle( instance, method_name )
    Eventorz::InvocationWrapper.new( instance, method_name);
  end
end
