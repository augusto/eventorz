class Module
  
  private
  
  # Adds 'event' keyword to define an event. With the following invocation
  #   class EventProducer
  #     event :my_event
  #   end
  #
  # it generates the following 3 methods
  #   on_my_event => used to fire the event (private)
  #   my_event => used to return the event handler (public)
  #   my_event= => used to assign the new event handler (public)
  #
  # The last 2 methods are used as syntactic sugar to make possible the syntax
  #   EventProducer.new.my_event += handle(:handler_method)
  def event(event_name)
    method_name = "on_#{event_name}"
    variable_name = "@event_#{event_name}"

    define_method method_name do |parameters|
      event_handler = instance_variable_get(variable_name)
      event_handler.fire( self, parameters)
    end
    private method_name
    
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