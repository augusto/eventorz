
module Eventorz
end

class Module
  
  private
  
  def event(event_name)
    method_name = "fire_#{event_name}"
    variable_name = "@event_#{event_name}"

    define_method method_name do
    end
    
    define_method event_name do
      var = instance_variable_get(variable_name)
      unless var
        var = Eventorz::EventHandler.new
        instance_varialbe_set(variable_name)
      end
      var
    end

    private method_name.to_sym
  end
  
end
