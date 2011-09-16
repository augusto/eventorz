
module Eventorz
  class EventHandler
  
    public
    def +(handler)
      handlers << handler
    end

    def fire(source, parameters)
      @handlers.each do |handler|
        handler.fire( source, parameters)
      end
    end

    private
    def handlers
      @handlers ||= []
    end
  end

  class InvocationWrapper
    def initialize(target, method_name)
      @target = target
      @method_name = method_name
    end

    def fire(source, parameters)
      @target.send @method_name, source, parameters
    end

    def ==(other)
      return false unless other.respond_to?(:target) and other.respond_to?(:method_name)
      self.target == other.target and self.method_name == other.method_name
    end

    protected
    attr_accessor :target, :method_name;

    public 
    def to_s
      "#{self.class}:target=#{self.target};method=#{self.method_name}"
    end
  end

end



class Module
  
  private
  
  def event(event_name)
    method_name = "on_#{event_name}"
    variable_name = "@event_#{event_name}"

    define_method method_name do |parameters|
      event_handler = instance_variable_get(variable_name)
      event_handler.fire( self, parameters)
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
  #
  # Adds an event handler. The method can be invoked with an implicit target (defatuls to self)
  #   object.event_name += handle :method_name
  # or with an explicit target object
  #   object.event_name += handle instance, :method_name
  #
  private
  def handle( *args )
    if args.length == 1 
      Eventorz::InvocationWrapper.new self,    args[0]
    elsif args.length == 2
      Eventorz::InvocationWrapper.new args[0], args[1]
    end
  end
end
